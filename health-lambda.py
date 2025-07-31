import boto3
import os
import logging
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):

    logger.info(f"Received event: {json.dumps(event)}")

    sns_client = boto3.client('sns')
    topic_arn = os.environ.get('SNS_TOPIC_ARN')
    event_rule_name = os.environ.get('EVENT_RULE_NAME')
    alarm_subject_prefix = os.environ.get('ALARM_SUBJECT_PREFIX')

    logger.info(f"Using SNS Topic ARN: {topic_arn}")
    logger.info(f"Using Event Rule Name: {event_rule_name}")
    logger.info(f"Using Alarm Subject Prefix: {alarm_subject_prefix}")

 
    # Get customer name from environment variable
    customer_name = event_rule_name.split('-')[-1]
    logger.info(f"Extracted customer name: {customer_name}")
 
    # Format the subject line with a single set of brackets
    event_subject = f' ALARM: "{alarm_subject_prefix}-aws-health-event-{event["detail"]["eventTypeCode"]}-{customer_name}" in {event["region"]}'
 

    logger.info(f"Formatted event subject: {event_subject}")
    event_message = "".join(
        [
            f'{event["detail"]["service"]}\n',
            f'Event Type: {event["detail"]["eventTypeCode"]}\n',
            f'Status: {event["detail"]["statusCode"]}\n',
            event["detail"]["eventDescription"][0]["latestDescription"],
        ]
    )

    try:
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
        logger.info(response)
    except Exception as err:
        logger.error(f"Error publing SNS message: {err}")

