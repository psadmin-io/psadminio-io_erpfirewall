class io_erpfirewall (
  $ensure                    = hiera('ensure', 'present'),
  $psft_install_user_name    = hiera('psft_install_user_name', undef),
  $oracle_install_group_name = hiera('oracle_install_group_name', undef),
  $domain_user               = hiera('domain_user', undef),
  $pia_domain_list           = hiera_hash('pia_domain_list', undef),
  $appserver_domain_list     = hiera_hash('appserver_domain_list', undef),
  $library_base              = undef,
  $pia                       = undef,
  $appserver                 = undef,
) {

  case $::osfamily {
    'windows': {
      $fileowner       = $domain_user
      $library_platform = 'Windows'
    }
    default: {
      $fileowner       = $psft_install_user_name
      
      $library_platform = 'Unix'
    }
  }

  if ($pia) {
    contain ::io_erpfirewall::pia
  }
  if ($appserver) {
    contain ::io_appserver::appserver
  }


}
