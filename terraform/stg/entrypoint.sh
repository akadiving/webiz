#!/bin/bash
apt-get update -y
apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install -i /usr/local/aws-cli -b /usr/local/bin

# Replace 'example_secret' with your secret's name and 'your_region' with your AWS region
SECRET=$(aws secretsmanager get-secret-value --secret-id docker_credentials --region eu-central-1 --query SecretString --output text)

# If your secret is a JSON object with key/value pairs, you can parse it with jq
export DOCKER_USERNAME=$(echo $SECRET | jq -r .DOCKER_USERNAME)
export DOCKER_PASSWORD=$(echo $SECRET | jq -r .DOCKER_PASSWORD)
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install -y docker-ce
systemctl start docker
systemctl enable docker
echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin

docker run -p 80:5000 akadiving/webiz