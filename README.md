
# io_erpfirewall

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with io_erpfirewall](#setup)
    * [What io_erpfirewall affects](#what-io_erpfirewall-affects)
    * [Beginning with io_erpfirewall](#beginning-with-io_erpfirewall)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)

## Description

This module will install the Appsian EPR Firewall libaries and configure the web server filters. There are multiple locations that `.jar` files exist for the product, and this module ensures that all locations are updated. (You must provide the source files, this module will put them in the correct location). The module will also update the `web.xml` file so the ERP Firewall filter is correctly added.

## Setup

### What io_erpfirewall affects **OPTIONAL**

This module affects the following locations and files:

* `PS_HOME\class` or `PS_CUST_HOME\class` for app server libraries
* `PIA_HOME\peoplesoft\applications\PORTAL.war\WEB-INF\web.xml`
* `PIA_HOME\peoplesoft\applications\lib`
* `PIA_HOME\peoplesoft\applications\PORTAL.war\lib`
* `PIA_HOME\peoplesoft\applications\PORTAL.war\gsdocs`

### Beginning with io_erpfirewall  

This module requires a source directory storing all the `.jar` files that the ERP Firewall uses. The source directory is expected to look like this:

```
tree C:\dpk\files\erpfirewall
C:\dpk\files\erpfirewall
├───appserver
│   └───Windows
│   └───Linux
└───pia
    └───Windows
    |   ├───lib
    |   └───PORTAL.war
    |       └───WEB-INF
    |           ├───gsdocs
    |           └───lib
    └───Linux
        ├───lib
        └───PORTAL.war
            └───WEB-INF
                ├───gsdocs
                └───lib


## Usage

1. Copy the `io_erpfirewall` module code into your `DPK_HOME\modules` folder.
1. In your `psft_customizations.yaml` file, add the `io_erpfirewall::*` parameters to configure the module.
1. Add `contain ::io_erpfirewall` to your DPK Role.

## Reference

The following configuration options are avialable via `psft_customizations.yaml`.

```yaml
io_erpfirewall::library_base:     'puppet:///modules/io_deploy/erpfirewall/'
io_erpfirewall::appserver:        true
io_erpfirewall::pia:              true
io_erpfirewall::use_ps_cust_home: true
```

* `library_base`: The source folder for the ERP Firewarll binaries to deploy. This location must be accessible on each machine.
* `appserver`: Enables the deployment of app server libraries. Default is `true`.
* `pia`: Enables the configuration and deployment of web server libraries. Default is `true`.
* `use_ps_cust_home`: On the application server, the ERP Firewall libraries will deploy to `PS_HOME/class`. Default is `false`. Set this parameter to deploy the libraries to `PS_CUST_HOME/class`. If you set this, you must also update `psappsrv.cfg` to have this line:

```ini
[PSTOOLS]
Add to CLASSPATH:     '%PS_CUST_HOME%\class'
```
or you can add this to the `psft_customizations.yaml` file under your `appserver_domain_list`:

```yaml
    config_settings:
      PSTOOLS/Add to CLASSPATH:     '%PS_CUST_HOME%\class'
```

  