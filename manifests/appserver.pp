# Class: io_erpfirewall::appserver
#
#
class io_erpfirewall::appserver (
  $psft_runtime_user_name       = $io_erpfirewall::psft_runtime_user_name,
  $appserver_domain_list        = $io_erpfirewall::appserver_domain_list,
  $library_platform             = $io_erpfirewall::library_platform,
  $archive_location             = $io_erpfirewall::archive_location,
  $ps_config_home               = $io_erpfirewall::ps_config_home,
) inherits io_erpfirewall {
  notify { 'Deploying appserver files for ERP Firewall': }

  $appserver_domain_list.each |$domain_name, $appserver_domain_info| {
    notify {"${domain_name} App Deploy Location: ${ps_config_home}": }

    case $library_platform {
      default: {
        exec { "Unix ERP Firewall Application Server Install: ${domain_name} ${ps_config_home}":
          command => "${archive_location}/AppServer/Unix/asp_app.bin ${ps_config_home}",
          creates => "${ps_config_home}/appserv/classes/gs-util.jar",
          user    => $psft_runtime_user_name,
        }
      }
      'Windows': {
        exec { "Windows ERP Firewall Application Server Install: ${domain_name} ${ps_config_home}":
          command  => "copy-item ${archive_location}/AppServer/Windows/asp_app.exe \${Env:temp};
                \${Env:temp}/asp_app.exe `
                /log=\"\${Env:TEMP}/appserver-installation.log\" `
                /verysilent `
                /suppressmsgboxes `
                /pshome=\"${ps_config_home}\"",
          creates  => "${ps_config_home}/classes/gs-util.jar",
          provider => powershell,
        }
      }
    } # end case ${library_platform}

  }

}
