class io_erpfirewall (
  $ensure                    = hiera('ensure', 'present'),
  $psft_install_user_name    = hiera('psft_install_user_name', undef),
  $oracle_install_group_name = hiera('oracle_install_group_name', undef),
  $pia_domain_list           = hiera_hash('pia_domain_list', undef),
  $appserver_domain_list     = hiera_hash('appserver_domain_list', undef),
  $library_base              = undef,
  $pia                       = undef,
  $appserver                 = undef,
  $app_deploy_location       = undef,
  $ps_home_location          = hiera('ps_home_location', undef),
  $ps_cust_home_location     = hiera('ps_cust_home_location', undef),
  $ps_config_home            = hiera('ps_config_home', undef),
  $archive_location          = hiera('archive_location', undef),
  $redeploy_firewall         = hiera('redeploy_firewall', undef)
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
