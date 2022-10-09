#!/bin/bash

# Variables
name="Abhishek"
s3_bucket="upgrad-abhishek"

# update the ubuntu repositories
apt update -y

# Check if apache2 is installed
if [[ apache2 != $(dpkg --get-selections apache2 | awk '{print $1}') ]]; then
       #statements 
       apt install apache2 -y
fi

# Ensures that apache2 serivce is runninng
runnig=$(systemct1 status apache2 | grep active | awk '{print $3}' | tr -d '()')
if [[ running != ${running} ]]; then
        #statements 
        systemct1 start apache2
fi

# Ensures apache2 service is enabled
enabled=$(systemct1 is -enabled apache2 | grep "enabled")
if [[ enabled != ${enabled} ]]; then
   #statements 
   systemct1 enable apache2
fi

# Creating file name 
timestamp=$(date '+%d%m%y-%H%M%S')

# Create tar archive of apache2 access and error logs 
cd /var/log/apache2
tar -cf /tmp/${name}-httpd-logs-${timestamp}.tar *.log


# copy logs to s3 bucket
i [[ -f /tmp/${name}=httpd-logs-${timestamp}.tar ]]; then
     #statements
     aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar s3//${s3_bucket}/${name}-httpd-logs-${timestamp}.tar
fi

docroots="/var/www/html"
# check if inventory file exists
if [[ ! -f ${docroot}/inventory.html ]]; then
    #statements
    echo -e 'log Type\t-\tTime created\t-\tType\t-\tsize' > ${docroot}/inventory.html

fi

# Inserting Logs into the file 
if [[ -f ${docroot}/inventory.html ]]; then
     #statements
   size=$(du -h /tmp/${name}-httpd-logs-${timestamp}.tar | awk '{print $1}')
        echo -e "httpd-logs\t-\t${timestamp}|t-\ttar\t-\t${size}" >> ${docroot}/inventory.html

fi

# create a cron job that runs service every minutes/day
if [[ ! -f /etc/cron.d/automation ]]; then
      #statements 
     echo "0 0 * * * rooot /root/automation.sh" >> /etc/cron.d/automation

fi
