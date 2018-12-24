# Class: io_erpfirewall::pia
#
#
class io_erpfirewall::pia (
  $ensure          = $io_erpfirewall::ensure,
  $pia_domain_list = $io_erpfirewall::pia_domain_list,
){
  notify { 'Deploying PIA files for ERP Firewall': } 
  
  $pia_domain_list.each |$domain_name, $pia_domain_info| {

  }
}