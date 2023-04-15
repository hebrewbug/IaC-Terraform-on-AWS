#! /bin/bash
# Instance Identity Metadata Reference - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-identity-documents.html


#Install Apapche
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo service httpd start  
sudo echo '<h1>Welcome to your application</h1>' | sudo tee /var/www/html/index.html
sudo mkdir /var/www/html/application
sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Your test page</h1> <p>Everything is working as it should</p> <p>This is your customers faced application</p> </body></html>' | sudo tee /var/www/html/application/index.html

# Install Datadog Agent. Replace Datadog API key with your key
DD_API_KEY="00000000000000000" DD_SITE="datadoghq.eu" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"

# Add Apache log config to Datadog
sudo tee /etc/datadog-agent/conf.d/apache.d/conf.yaml << EOF
## All options defined here are available to all instances.
init_config:

instances:

  - apache_status_url: http://localhost/server-status?auto

    
    disable_generic_tags: true

logs:
  - type: file
    path: /var/log/httpd/access_log
    source: apache
    service: apache
EOF

# Set read access for Datadog Agent user
sudo setfacl -Rm u:dd-agent:rx /var/log/httpd

# Restart Datadog Agent
sudo restart datadog-agent

sudo curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app1/metadata.html
