# Class: io_erpfirewall::pia
#
#
class io_erpfirewall::pia () inherits io_erpfirewall {
  notify { 'Deploying PIA files for ERP Firewall': }

  # $deploy_source = "${library_base}/pia/${library_platform}"

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $udomain_name = upcase($domain_name)

    case $library_platform {
      default: {
        exec { 'install_erpfirewall':
          command => "/usr/bin/su -m -s /bin/bash - ${psft_runtime_user_name} -c \"${archive_location}/ERP_Firewall/WebServer/Unix/gh_firewall_web.bin ${ps_config_home} ${domain_name}\"",
          creates => "${ps_config_home}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/gsdocs",
        }

        file { "${ps_config_home}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/lib/psjoa.jar" :
          source  => "${ps_home_location}/appserv/classes/psjoa.jar",
          owner   => $psft_runtime_user_name,
          mode    => '0755',
          require => Exec['install_erpfirewall'],
        }
      } # default

      'Windows': {
        file { "${ps_config_home}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/lib/psjoa.jar" :
          source => "${ps_home_location}/class/psjoa.jar",
          owner  => $psft_runtime_user_name,
          mode   => '0755',
        }
        -> exec { 'copy_erpfirewall_installer':
          command  => "copy-item ${archive_location}/ERP_Firewall/WebServer/Windows/gh_firewall_web.exe c:/temp",
          creates  => 'c:/temp/gh_firewall_web.exe',
          provider => powershell,
        }
        -> exec { 'install_erpfirwall':
          command  => "& \"c:/temp/gh_firewall_web.exe\" /log=\"c:/temp/erpfirewall-webserver-installation.log\" /verysilent /suppressmsgboxes /pshome=\"${ps_config_home}\" /piadomain=\"${udomain_name}\"",
          creates  => "${ps_config_home}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/gsdocs",
          provider => powershell,
        }
        -> xml_fragment { "${domain_name}_fail_open":
          ensure  => 'present',
          path    => "${ps_config_home}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/web.xml",
          xpath   => "/web-app/filter[filter-name='gs_erp_firewall']/init-param/param-value",
          content => {
              value   => 'true'
            }
        }
      } # windows 

    } # case platform
  } # pia_domain_list
}
