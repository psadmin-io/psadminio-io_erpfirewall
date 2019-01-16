# Class: io_erpfirewall::appserver
#
#
class io_erpfirewall::appserver () inherits io_erpfirewall {
  notify { 'Deploying appserver files for ERP Firewall': }

  $appserver_domain_list.each |$domain_name, $appserver_domain_info| {
    notify {"${domain_name} App Deploy Location: ${app_deploy_location}": }

    case $library_platform {
      default: {
        exec { "Unix ERP Firewall Application Server Install: ${app_deploy_location}":
          command => "${archive_location}/ERP_Firewall/AppServer/Unix/gh_fwappserv.bin ${app_deploy_location}",
          creates => "${app_deploy_location}/appserv/classes/gs-util.jar",
          user    => $psft_install_user_name,
        }
      }
      'Windows': {
        exec { "Windows ERP Firewall Application Server Install: ${app_deploy_location}":
          command => "copy-item ${archive_location}/ERP_Firewall/AppServer/Windows/setup.exe \${Env:temp};
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

  # if $use_ps_cust_home == true {
  #   $deploy_location = "${ps_cust_home_location}/class"
  # } else {
  #   $deploy_location = "${ps_home_location}/class"
  # }

  # $deploy_source = "${library_base}/appserver/${library_platform}"

  # $appserver_domain_list.each |$domain_name, $appserv_domain_info| {
  #   file {"ERPFirewall-AppServer-${domain_name}":
  #     ensure  => file,
  #     source  => $deploy_source,
  #     recurse => true,
  #     path    => $deploy_location,
  #     owner   => $psft_runtime_user_name,
  #     group   => $psft_runtime_group_name,
  #     mode    => '0644',
  #   }
  # }
}
