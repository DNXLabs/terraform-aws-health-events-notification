import boto3
import json
import os

def lambda_handler(event, context):
    sns_client = boto3.client('sns')
    topic_arn = os.environ.get('SNS_TOPIC_ARN')
    event_rule_name = os.environ.get('EVENT_RULE_NAME')

    rule_base = event_rule_name.replace("dnx-aws-health-event-", "").replace("-ec2-instance-state-change", "")
    
    event_subject = f' ALARM: "dnx-aws-health-event-ec2-instance-state-change-{rule_base}" in {event["region"]}'
    event_message = "".join(
        [
            f'{event["detail"]["service"]}\n',
            f'Event Type: {event["detail"]["eventTypeCode"]}\n',
            f'Status: {event["detail"]["statusCode"]}\n',
            event["detail"]["eventDescription"][0]["latestDescription"],
        ]
    )

    response = sns_client.publish(
        TopicArn=topic_arn,
        Message=event_message,
        Subject=event_subject,
        MessageAttributes={
            'string': {
                'DataType': 'String',
                'StringValue': 'String'
            }
        }
    )

    print(response)
