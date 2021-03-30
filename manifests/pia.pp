# Class: io_erpfirewall::pia
#
#
class io_erpfirewall::pia (
  $psft_runtime_user_name = $io_erpfirewall::psft_runtime_user_name,
  $pia_domain_list        = $io_erpfirewall::pia_domain_list,
  $library_platform       = $io_erpfirewall::library_platform,
  $archive_location       = $io_erpfirewall::archive_location,
  $ps_config_home         = $io_erpfirewall::ps_config_home,
  $ps_home_location       = $io_erpfirewall::ps_home_location,
  $redeploy_firewall      = $io_erpfirewall::redeploy_firewall,
  $java_home_location     = $io_erpfirewall::java_home_location,
) inherits io_erpfirewall {
  notify { 'Deploying PIA files for ERP Firewall': }

  # $deploy_source = "${library_base}/pia/${library_platform}"

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    # $udomain_name = upcase($domain_name)

    case $library_platform {
      default: {
        exec { "install_erpfirewall-${domain_name}":
          command => "/bin/su -m -s /bin/bash - ${psft_runtime_user_name} -c \"${archive_location}/WebServer/Unix/gh_firewall_web.bin ${ps_config_home} ${domain_name}\"",
          creates => "${ps_config_home}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/gsdocs",
        }
        -> file { "${ps_config_home}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/lib/psjoa.jar" :
          source => "${ps_home_location}/appserv/classes/psjoa.jar",
          owner  => $psft_runtime_user_name,
          mode   => '0755',
        }
      } # default

      'Windows': {

        if( $redeploy_firewall = 'true') {
          file {"${domain_name}_remove_gsdocs":
            ensure => absent,
            path   => "${ps_config_home}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/gsdocs",
            force  => true,
          }
        }

        file { "${ps_config_home}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/lib/psjoa.jar" :
          source => "${ps_home_location}/class/psjoa.jar"
        }

        file { "${domain_name}_c_temp":
          ensure => directory,
          path   => 'c:/temp',
        }
        -> exec { "${domain_name}_copy_erpfirewall_installer":
          command  => "copy-item ${archive_location}/WebServer/Windows/gh_firewall_web.exe c:/temp",
          # creates  => 'c:/temp/gh_firewall_web.exe',
          provider => powershell,
        }
        -> exec { "${domain_name}_install_erpfirwall":
          command  => "\$env:JAVA_HOME=\"${java_home_location}\"; \$env:PATH=\"\${env:PATH};\${env:JAVA_HOME}\\bin}\"; & \"c:/temp/gh_firewall_web.exe\" /log=\"c:/temp/erpfirewall-webserver-installation.log\" /verysilent /suppressmsgboxes /pshome=\"${ps_config_home}\" /piadomain=\"${domain_name}\"; sleep 30",
          creates  => "${ps_config_home}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/gsdocs",
          provider => powershell,
        }
        -> xml_fragment { "${domain_name}_fail_open":
          ensure  => 'present',
          path    => "${ps_config_home}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/web.xml",
          xpath   => "/web-app/filter[filter-name='gs_erp_firewall']/init-param/param-value",
          content => {
              value   => 'true',
            }
        }
      } # windows 

    } # case platform

    $site_list   = $pia_domain_info['site_list']
    if $site_list {
      $site_list.each |$site_name, $site_info| {

          $disable_file   = "${ps_config_home}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/gsdocs/site_${site_name}_disabled.txt"
          file {"disable_erpfirewall_${site_name}":
            ensure => $site_info['appsian_disable'],
            path   => $disable_file,
          }

      } # end site_list
    }

  } # pia_domain_list
}
