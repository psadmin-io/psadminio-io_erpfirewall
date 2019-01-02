# Class: io_erpfirewall::pia
#
#
class io_erpfirewall::pia () inherits io_erpfirewall {
  notify { 'Deploying PIA files for ERP Firewall': }

  $deploy_source = "${library_base}/pia/${library_platform}"

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    $deploy_location = "${ps_config_home}/webserv/${domain_name}/applications/peoplesoft"

    file {"ERPFirewall-PIA-lib-${domain_name}":
      ensure  => file,
      source  => "${deploy_source}/lib",
      recurse => true,
      path    => "${deploy_location}/lib",
      owner   => $psft_runtime_user_name,
      group   => $psft_runtime_group_name,
      mode    => '0644',
    }

    file {"ERPFirewall-PIA-WEB-INF-gsdocs-${domain_name}":
      ensure  => file,
      source  => "${deploy_source}/PORTAL.war/WEB-INF/gsdocs",
      recurse => true,
      path    => "${deploy_location}/PORTAL.war/WEB-INF/gsdocs",
      owner   => $psft_runtime_user_name,
      group   => $psft_runtime_group_name,
      mode    => '0644',
    }

    file {"ERPFirewall-PIA-WEB-INF-lib-${domain_name}":
      ensure  => file,
      source  => "${deploy_source}/PORTAL.war/WEB-INF/lib",
      recurse => true,
      path    => "${deploy_location}/PORTAL.war/WEB-INF/lib",
      owner   => $psft_runtime_user_name,
      group   => $psft_runtime_group_name,
      mode    => '0644',
    }

    # $filter_content = {
    #   'filter-name' => 'gs_erp_firewall',
    #   'filter-class'=>'com.greyheller.firewall.Psfw',
    #   'async-supported' => true,
    #   'init-param' => {
    #     'param-name' => 'failopen',
    #     'param-value' => false
    #     }
    #   }

    # notify { "Filter Content Hash: ${filter_content}":}

    # xml_fragment {"ERPFirewall-web-xml-${domain_name}":
    #   ensure  => $ensure,
    #   xpath   => "/web-app/filter/filter-name[text()='gs_erp_firewall']",
    #   path    => "${deploy_location}/PORTAL.war/WEB-INF/web.xml",
    #   content => {
    #     'filter-name'     => 'gs_erp_firewall',
    #     'filter-class'    =>'com.greyheller.firewall.Psfw',
    #     'async-supported' => true,
    #     'init-param'      => {
    #       'param-name'  => 'failopen',
    #       'param-value' => false
    #       }
    #     },
    # }

    $filter_match = '    <filter-name>gs_erp_firewall</filter-name>'
    $filter_line = "
  <filter>
    <filter-name>gs_erp_firewall</filter-name>
    <filter-class>com.greyheller.firewall.Psfw</filter-class>
    <async-supported>true</async-supported>
    <init-param>
      <param-name>failopen</param-name>
      <param-value>false</param-value>
    </init-param>
  </filter>
  <filter-mapping>
    <filter-name>gs_erp_firewall</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>
"

    file_line { "ERPFirewall-web-xml-filter-${domain}":
      path    => "${deploy_location}/PORTAL.war/WEB-INF/web.xml",
      line    => $filter_line,
      match   => $filter_match,
      after   => '  <!-- <distributable/> -->',
      replace => false,
    }

#     $filter_mapping_match = "    <filter-name>gs_erp_firewall</filter-name>"
#     $filter_mapping_line = "
#   <filter-mapping>
#     <filter-name>gs_erp_firewall</filter-name>
#     <url-pattern>/*</url-pattern>
#   </filter-mapping>
# "

#     file_line { "ERPFirewall-web-xml-filter-mapping-${domain}":
#       path    => "${deploy_location}/PORTAL.war/WEB-INF/web.xml",
#       line    => $filter_mapping_line,
#       match   => $filter_mapping_match,
#       after   => '  </filter-mapping>',
#       replace => false,
#     }

  }
}