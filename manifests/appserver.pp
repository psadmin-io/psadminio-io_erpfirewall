# Class: io_erpfirewall::appserver
#
#
class io_erpfirewall::appserver () inherits io_erpfirewall {
  notify { 'Deploying appserver files for ERP Firewall': }

  $appserver_domain_list.each |$domain_name, $appserver_domain_info| {
    notify {"${domain_name} App Deploy Location: ${app_deploy_location}": }

    case $library_platform {
      default: {
        exec { "Unix ERP Firewall Application Server Install: ${domain_name} ${app_deploy_location}":
          command => "${archive_location}/AppServer/Unix/gh_fwappserv.bin ${app_deploy_location}",
          creates => "${app_deploy_location}/appserv/classes/gs-util.jar",
          user    => $psft_install_user_name,
        }
      }
      'Windows': {
        exec { "Windows ERP Firewall Application Server Install: ${domain_name} ${app_deploy_location}":
          command => "copy-item ${archive_location}/AppServer/Windows/setup.exe \${Env:temp};
                \${Env:temp}/setup.exe `
                /log=\"\${Env:TEMP}/appserver-installation.log\" `
                /verysilent `
                /suppressmsgboxes `
                /pshome=\"${app_deploy_location}\"",
          creates => "${app_deploy_location}/classes/gs-util.jar",
          provider => powershell,
        }
      }
    } # end case ${library_platform}

  }

}
