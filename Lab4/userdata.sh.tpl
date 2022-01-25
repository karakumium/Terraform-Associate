#!/bin/bash
yum update 
yum install httpd -y
MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`


cat << EOF > /var/www/html/index.html
<html>
<h2> Built by Terraform</h2>

Server owner is: ${f_name} ${l_name} <br>

%{for x in names~}
Hello to ${x} from ${f_name} <br>
%{ endfor ~}
</html>
EOF

service httpd start
chkconfig httpd on