# Class: io_erpfirewall::appserver
#
#
class io_erpfirewall::appserver (
  $ensure                = $io_erpfirewall::ensure,
  $appserver_domain_list = $io_erpfirewall::appserver_domain_list,
){
  notify { 'Deploying appserver files for ERP Firewall': } 
  
  $appserver_domain_list.each |$domain_name, $appserv_domain_info| {
    
  }
}