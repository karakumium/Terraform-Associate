  #!/bin/bash
  yum update 
  yum install httpd -y
  MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
  echo "<h2>Web Fuck with IP:$MYIP</h2><br>Buid by Terraform external file" > /var/www/html/index.html
  service httpd start
  chkconfig httpd on
  