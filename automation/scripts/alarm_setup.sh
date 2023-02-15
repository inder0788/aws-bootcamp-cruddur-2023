#!/bin/sh
sns_name=$1
subscriber_email=$2

#Create SNS Topic
echo "###Creating SNS topic###"
sns_arn=$(aws sns create-topic --name $sns_name | jq -r '.TopicArn')
echo "SNS topic for Billing Alarm has arn- ${sns_arn}"

#Create Subscription
if [ -z "$subscriber_email" ]
then
	echo "###No Subscriber email provided###"
else
	echo "###Setting Subscription for the email ID###"
	subscribe_output=$(aws sns subscribe --topic-arn $sns_arn --protocol email --notification-endpoint $subscriber_email)
	echo $subscribe_output
fi

# Create Alarm using "EstimatedCharges" metric.
cat alarm.json | jq '.AlarmActions = [ $sns ]' --arg sns $sns_arn > alarm_config.json
echo "final alarm config saved in 'alarm_config.json' file for refereence."

echo "Creating CW Alarm now"
aws cloudwatch put-metric-alarm --cli-input-json file://alarm_config.json
