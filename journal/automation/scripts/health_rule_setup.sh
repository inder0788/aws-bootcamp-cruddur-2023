#!/bin/sh
cw_event_rule_name=$1
sns_name=$2

#Create CloudWatch Event Rule
echo "###Creating CloudWatch Event Rule for AWS Service Health Alerts###"
aws events put-rule --name $cw_event_rule_name --event-pattern file://health_event.json

#Create SNS Topic
echo "###Creating SNS topic for AWS Service Health Alerts###"
sns_arn=$(aws sns create-topic --name $sns_name | jq -r '.TopicArn')
echo "SNS topic for Health Monitor has arn- ${sns_arn}"

# Update Target config with SNS created earlier.
cat health_rule_target.json | jq '.Targets[].Arn = $sns ' --arg sns $sns_arn > health_rule_target_final.json
echo "CW Event Rule target config has been updated with SNS Arn."

#Adding SNS Target to CloudWatch Event Rule
echo "###Adding SNS as target to CloudWatch Event Rule###"
aws events put-targets --rule $cw_event_rule_name --cli-input-json file://health_rule_target_final.json
if [ $? -eq 0 ];then
    echo "CW rule configured with SNS target"
    echo "Deleting temp file"
    rm health_rule_target_final.json
fi


