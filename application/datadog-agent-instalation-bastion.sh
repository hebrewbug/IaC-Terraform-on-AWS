#! /bin/bash
#don't forget to provide correct Datadog API key
DD_API_KEY=$<YOUR DD API key> DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"