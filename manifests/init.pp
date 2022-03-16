class io_erpfirewall (
<<<<<<< HEAD
  $ensure                    = lookup('ensure', 'present', undef, undef, ''),
  $psft_runtime_user_name    = lookup('psft_runtime_user_name', 'psadm2', undef, undef, ''),
  $oracle_install_group_name = lookup('oracle_install_group_name', 'oinstall', undef, undef, ''),
  $pia_domain_list           = hiera('pia_domain_list', undef),
  $appserver_domain_list     = hiera('appserver_domain_list', undef),
=======
  $ensure                    = lookup('ensure', undef, undef, 'present'),
  $psft_runtime_user_name    = lookup('psft_runtime_user_name', undef, undef, 'psadm2'),
  $oracle_install_group_name = lookup('oracle_install_group_name', undef, undef, 'oinstall'),
  $pia_domain_list           = lookup('pia_domain_list', undef, undef, ''),
  $appserver_domain_list     = lookup('appserver_domain_list', undef, undef, ''),
>>>>>>> 00d3c28460fcf234ba6ef9c161793748d13ea33e
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
