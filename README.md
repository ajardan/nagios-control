nagios-control
==============

Nagios control utility

Usage: nagios-control.rb [options]

    -s, --server [HOSTNAME|IP]       Nagios server hostname
    -U, --user [USERNAME]            Username to be used when connecting to nagios
    -X, --password [PASSWORD]        Password to be used when connecting to nagios
    -p, --protocol [PROTO]           Protocol to use (http/https)
    -P, --path [PATH]                Path to nagios cmd.cgi
    -g, --group [GROUP]              The hostgroup to be used
    -h, --host [HOST]                The host to be used
    -e, --enable                     Enable action
    -d, --disable                    Disable action
    -S, --services-notifications     Notifications are enabled|disabled for hosts services
    -H, --hosts-notifications        Notifications are enabled|disabled for hosts
    -C, --services-checks            Checks of the services are enabled|disabled
    -v, --verbose                    Run verbose
        --help                       Show this message

