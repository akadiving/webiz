#!/bin/bash
# add user-data to a log file
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# start time, which will also be used by the end.sh script
start_time="$(date -u +%s.%N)"

# add your scripts here 
apt-get update -y
apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install -i /usr/local/aws-cli -b /usr/local/bin

# get secrets
SECRET=$(aws secretsmanager get-secret-value --secret-id docker_credentials --region eu-central-1 --query SecretString --output text)

# export secrets
export DOCKER_USERNAME=$(echo $SECRET | jq -r .DOCKER_USERNAME)
export DOCKER_PASSWORD=$(echo $SECRET | jq -r .DOCKER_PASSWORD)

# install docker
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install -y docker-ce
systemctl start docker
systemctl enable docker
echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin

# pull the image and run the container
docker run -p 80:5000 --restart always akadiving/webiz

# log the completed and
echo "Launch Script Completed"
end_time="$(date -u +%s.%N)"

elapsed="$(bc <<<"$end_time-$start_time")"
echo "Total of $elapsed seconds elapsed for script to run"