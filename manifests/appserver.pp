# Class: io_erpfirewall::appserver
#
#
class io_erpfirewall::appserver (
  $ensure                = $io_erpfirewall::ensure,
  $appserver_domain_list = $io_erpfirewall::appserver_domain_list,
<<<<<<< HEAD
  $use_ps_cust_home      = $io_erpfirewall::use_ps_cust_home,
  $ps_home_location      = $io_erpfirewall::ps_home_location,
  $ps_cust_home_location = $io_erpfirewall::ps_cust_home_location,
  $library_base          = $io_erpfirewall::library_base,
  $library_platform      = $io_erpfirewall::library_platform,
){
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
    }
=======
){
  notify { 'Deploying appserver files for ERP Firewall': } 
  
  $appserver_domain_list.each |$domain_name, $appserv_domain_info| {
    
>>>>>>> a530d80561fe9bd0d9b1334ebef215975b39bcfb
  }
}