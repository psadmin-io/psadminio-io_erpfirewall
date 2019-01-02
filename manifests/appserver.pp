# Class: io_erpfirewall::appserver
#
#
class io_erpfirewall::appserver () inherits io_erpfirewall {
  notify { 'Deploying appserver files for ERP Firewall': } 
  
  if $use_ps_cust_home == true {
    $deploy_location = "${ps_cust_home_location}/class"
  } else {
    $deploy_location = "${ps_home_location}/class"
  }

  $deploy_source = "${library_base}/appserver/${library_platform}"

  $appserver_domain_list.each |$domain_name, $appserv_domain_info| {
    file {"ERPFirewall-AppServer-${domain_name}":
      ensure => file,
      source => $deploy_source,
      recurse => true,
      owner  => $psft_runtime_user_name,
      group  => $psft_runtime_group_name,
      mode   => '0644',
    }
  }
}