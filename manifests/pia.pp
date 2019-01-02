# Class: io_erpfirewall::pia
#
#
class io_erpfirewall::pia () inherits io_erpfirewall {
  notify { 'Deploying PIA files for ERP Firewall': }

  $deploy_source = "${library_base}/pia/${library_platform}"

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    $deploy_location = "${ps_config_home}/webserv/${domain_name}/applications/peoplesoft"

    file {"ERPFirewall-PIA-${domain_name}":
      ensure  => file,
      source  => $deploy_source,
      recurse => true,
      path    => $deploy_location,
      owner   => $psft_runtime_user_name,
      group   => $psft_runtime_group_name,
      mode    => '0644',
    }
  }
}