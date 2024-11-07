import boto3
import json
import os

def lambda_handler(event, context):
    sns_client = boto3.client('sns')
    topic_arn = os.environ.get('SNS_TOPIC_ARN')
    event_rule_name = os.environ.get('EVENT_RULE_NAME')
    
    # Get customer name from environment variable
    customer_name = event_rule_name.split('-')[-1]
    
    # Format the event rule name with customer name
    formatted_rule_name = f"dnx-aws-health-event-{event['detail']['eventTypeCode']}-{customer_name}"
    
    # Format the subject line with a single set of brackets
    event_subject = f' ALARM: "dnx-aws-health-event-{event["detail"]["eventTypeCode"]}-{customer_name}" in {event["region"]}'
    
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
