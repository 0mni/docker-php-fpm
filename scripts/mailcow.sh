#!/bin/bash

### disable port 25
sed -i 's/smtp      inet/#smtp      inet/g' /etc/postfix/master.cf

postconf -e 'relayhost = $MAILCOW_MYRELAYHOST'
postconf -e "mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128"
postconf -e "inet_interfaces = loopback-only"
postconf -e "relay_transport = relay"
postconf -e "default_transport = smtp"
postconf -e "myhostname = $MAILCOW_MYHOSTNAME"
postconf -e "mydestination = \$myhostname, localhost.\$mydomain, localhost"

/etc/init.d/postfix start > /dev/null

### send test email if TEST_EMAIL env variable is set
if [ ! -z ${TEST_EMAIL+x} ] && [ "$TEST_EMAIL" != "" ]; then
    echo " - sending test email to: [ $TEST_EMAIL ]";
    php /usr/local/bin/emailtest.php
fi
