 #!/bin/bash
# A sample shell script to clean cached file from lighttpd web server
CROOT="/tmp/cachelighttpd/"
 
# Clean files every $DAYS
DAYS=10
 
# Web server username and group name
LUSER="lighttpd"
LGROUP="lighttpd"
 
# Okay, let us start cleaning as per $DAYS
/usr/bin/find ${CROOT} -type f -mtime +${DAYS} | xargs -r /bin/rm
 
# Failsafe 
# if directory deleted by some other script just get it back 
if [ ! -d $CROOT ]
then
        /bin/mkdir -p $CROOT
        /bin/chown ${LUSER}:${LGROUP} ${CROOT}
fi