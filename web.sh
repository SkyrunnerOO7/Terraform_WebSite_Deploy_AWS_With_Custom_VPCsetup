#!/bin/bash
yum install wget unzip httpd -y
systemctl start httpd
systemctl enable httpd
wget https://www.tooplate.com/zip-templates/2133_moso_interior.zip
unzip -o 2133_moso_interior.zip
cp -r 2133_moso_interior/* /var/www/html/
systemctl restart httpd