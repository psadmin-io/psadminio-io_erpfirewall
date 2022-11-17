class io_erpfirewall (
  $ensure                    = lookup('ensure', undef, undef, 'present'),
  $psft_runtime_user_name    = lookup('psft_runtime_user_name', undef, undef, 'psadm2'),
  $psft_install_user_name    = lookup('psft_install_user_name', undef, undev, 'psadm1'),
  $oracle_install_group_name = lookup('oracle_install_group_name', undef, undef, 'oinstall'),
  $pia_domain_list           = lookup('pia_domain_list', undef, undef, ''),
  $appserver_domain_list     = lookup('appserver_domain_list', undef, undef, ''),
  $library_base              = undef,
  $pia                       = undef,
  $appserver                 = undef,
  $app_deploy_location       = undef,
  $ps_home_location          = lookup('ps_home_location', undef, undef, ''),
  $ps_cust_home_location     = lookup('ps_cust_home_location', undef, undef, ''),
  $ps_config_home            = lookup('ps_config_home', undef, undef, ''),
  $archive_location          = lookup('archive_location', undef, undef, ''),
  $redeploy_firewall         = lookup('redeploy_firewall', undef, undef, ''),
  $java_home                 = lookup('jdk_location', undef, undef, '')
) {

  case $::osfamily {
    'windows': {
      $library_platform = 'Windows'
    }
    default: {
      $library_platform = 'Unix'
    }
  }

  if ($pia) {
    contain ::io_erpfirewall::pia
  }
  if ($appserver) {
    contain ::io_erpfirewall::appserver
  }


}
