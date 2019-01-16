# Class: io_erpfirewall::pia
#
#
class io_erpfirewall::pia () inherits io_erpfirewall {
  notify { 'Deploying PIA files for ERP Firewall': }

  # $deploy_source = "${library_base}/pia/${library_platform}"

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    case $library_platform {
      default: {
        exec { 'install_erpfirewall':
          command => "/usr/bin/su -m -s /bin/bash - ${psft_runtime_user_name} -c \"${archive_location}/ERP_Firewall/WebServer/Unix/gh_firewall_web.bin ${ps_config_home} ${pia_domain_name}\"",
          creates => "${ps_config_home}/webserv/${pia_domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/gsdocs",
        }

        file { "${ps_config_home}/webserv/${pia_domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/lib/psjoa.jar" :
          source  => "${ps_home_location}/appserv/classes/psjoa.jar",
          owner   => $psft_runtime_user_name,
          mode    => '0755',
          require => Exec['install_erpfirewall'],
        }
      }

      'Windows': {
        exec { 'install_erpfirewall':
          command  => "copy-item ${archive_location}/ERP_Firewall/WebServer/Windows/gh_firewall_web.exe \${Env:temp}; `
              \${Env:temp}/gh_firewall_web.exe `
              /log=\"\${Env:TEMP}/erpfirewall-webserver-installation.log\" `
              /verysilent `
              /suppressmsgboxes `
              /pshome=\"${ps_config_home}\" `
              /piadomain=\"${domain_name}\"",
          creates  => "${ps_config_home}/webserv/${pia_domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/gsdocs",
          provider => powershell,
        } ->
        file { "${ps_config_home}/webserv/${pia_domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/lib/psjoa.jar" :
          source  => "${ps_home_location}/class/psjoa.jar",
          owner   => $psft_runtime_user_name,
          mode    => '0755',
          require => Exec['install_erpfirewall'],
        }
      }
    } # case platform

  } # pia_domain_list

}
