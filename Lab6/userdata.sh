#!/bin/bash
yum update 
yum install httpd -y
MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`


cat << EOF > /var/www/html/index.html
<html>
<h2> Built by Terraform</h2>
<br>
Private IP: $MYIP
<br>
Web server with static IP <br>
<p>
<font color="blue">Version 4</font>
</html>
EOF

service httpd start
chkconfig httpd on