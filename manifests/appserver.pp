# Class: io_erpfirewall::appserver
#
#
class io_erpfirewall::appserver (
  $psft_runtime_user_name       = $io_erpfirewall::psft_runtime_user_name,
  $appserver_domain_list        = $io_erpfirewall::appserver_domain_list,
  $library_platform             = $io_erpfirewall::library_platform,
  $archive_location             = $io_erpfirewall::archive_location,
  $ps_home_location             = $io_erpfirewall::ps_home_location,
) inherits io_erpfirewall {
  notify { 'Deploying appserver files for ERP Firewall': }

  $appserver_domain_list.each |$domain_name, $appserver_domain_info| {
    notify {"${domain_name} App Deploy Location: ${ps_home_location}": }

    case $library_platform {
      default: {
        exec { "Unix ERP Firewall Application Server Install: ${domain_name} ${ps_home_location}":
          command => "${archive_location}/AppServer/Unix/asp_app.bin ${ps_home_location}",
          creates => "${ps_home_location}/appserv/classes/gs-util.jar",
          user    => $psft_runtime_user_name,
        }
      }
      'Windows': {
        exec { "Windows ERP Firewall Application Server Install: ${domain_name} ${ps_home_location}":
          command  => "copy-item ${archive_location}/AppServer/Windows/asp_app.exe \${Env:temp};
                \${Env:temp}/asp_app.exe `
                /log=\"\${Env:TEMP}/appserver-installation.log\" `
                /verysilent `
                /suppressmsgboxes `
                /pshome=\"${ps_home_location}\"",
          creates  => "${ps_home_location}/classes/gs-util.jar",
          provider => powershell,
        }
      }
    } # end case ${library_platform}

  }

}
