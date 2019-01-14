# Class: io_erpfirewall::pia
#
#
class io_erpfirewall::pia () inherits io_erpfirewall {
  notify { 'Deploying PIA files for ERP Firewall': }

  # $deploy_source = "${library_base}/pia/${library_platform}"

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    if ${library_platform} == "Unix" {
      exec { 'install_erpfirewall':
        command => "/usr/bin/su -m -s /bin/bash - ${psft_runtime_user_name} -c \"${archive_location}/ERP_Firewall/WebServer/Unix/gh_firewall_web.bin ${ps_config_home} ${pia_domain_name}\"",
        creates => "${ps_config_home}/webserv/${pia_domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/gsdocs",
      }

      file { "${ps_config_home}/webserv/${pia_domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/lib/psjoa.jar" :
        source  => "${ps_home_location}/appserv/classes/psjoa.jar",
        owner   => $psft_runtime_user_name,
        mode    => '0755',
        require => Exec['install_erpfirewall'],
      }
    }

    if ${library_platform} == "Windows" {
      exec { 'install_erpfirewall':
        command => "${archive_location}/ERP_Firewall/WebServer/Windows/gh_firewall_web.exe `
            /log=\"${Env:TEMP}\erpfirewall-webserver-installation.log\" `
            /verysilent `
            /suppressmsgboxes `
            /pshome=\"{ps_config_home}\" `
            /piadomain=\"${domain_name}\""
        creates => "${ps_config_home}/webserv/${pia_domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/gsdocs",
      }

      file { "${ps_config_home}/webserv/${pia_domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/lib/psjoa.jar" :
        source  => "${ps_home_location}/appserv/classes/psjoa.jar",
        owner   => $psft_runtime_user_name,
        mode    => '0755',
        require => Exec['install_erpfirewall'],
      }
    }

    # $deploy_location = "${ps_config_home}/webserv/${domain_name}/applications/peoplesoft"

#     file {"ERPFirewall-PIA-lib-${domain_name}":
#       ensure  => file,
#       source  => "${deploy_source}/lib",
#       recurse => true,
#       path    => "${deploy_location}/lib",
#       owner   => $psft_runtime_user_name,
#       group   => $psft_runtime_group_name,
#       mode    => '0644',
#     }

#     file {"ERPFirewall-PIA-WEB-INF-gsdocs-${domain_name}":
#       ensure  => file,
#       source  => "${deploy_source}/PORTAL.war/WEB-INF/gsdocs",
#       recurse => true,
#       path    => "${deploy_location}/PORTAL.war/WEB-INF/gsdocs",
#       owner   => $psft_runtime_user_name,
#       group   => $psft_runtime_group_name,
#       mode    => '0644',
#     }

#     file {"ERPFirewall-PIA-WEB-INF-lib-${domain_name}":
#       ensure  => file,
#       source  => "${deploy_source}/PORTAL.war/WEB-INF/lib",
#       recurse => true,
#       path    => "${deploy_location}/PORTAL.war/WEB-INF/lib",
#       owner   => $psft_runtime_user_name,
#       group   => $psft_runtime_group_name,
#       mode    => '0644',
#     }

#     $filter_match = '<filter-name>gs_erp_firewall</filter-name>'
#     $filter_line = "
#   <filter>
#     <filter-name>gs_erp_firewall</filter-name>
#     <filter-class>com.greyheller.firewall.Psfw</filter-class>
#     <async-supported>true</async-supported>
#     <init-param>
#       <param-name>failopen</param-name>
#       <param-value>false</param-value>
#     </init-param>
#   </filter>
#   <filter-mapping>
#     <filter-name>gs_erp_firewall</filter-name>
#     <url-pattern>/*</url-pattern>
#   </filter-mapping>
# "

#     file_line { "ERPFirewall-web-xml-filter-${domain}":
#       path    => "${deploy_location}/PORTAL.war/WEB-INF/web.xml",
#       line    => $filter_line,
#       match   => $filter_match,
#       after   => '<!-- <distributable/> -->',
#       replace => false,
#     }

  }
}