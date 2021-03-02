import os
import json
from urllib import request, parse

def lambda_handler(event, context):
    url = 'https://api.telegram.org/bot{}/sendMessage'.format(os.environ['TOKEN'])
    message = event['Records'][0]['Sns']['Message']

    # if it is a json string, parse it and generate formatted alarm msg
    try:
        message = json.loads(message)
        message = create_alarm_msg(message)
    except Exception:
        pass

    data = parse.urlencode({
        'chat_id': os.environ['CHAT_ID'],
        'text': message
    })
    try:
        request.urlopen(url, data.encode('utf-8'))
    except Exception as e:
        print('Failed to send the SNS message below:\n{}'.format(chunk))
        raise e

def create_alarm_msg(raw_msg):
    msg = ""
    if all(["AlarmName", "NewStateValue", "StateChangeTime"]) in raw_msg:
        msg += "AlarmName: {}\n".format(raw_msg["AlarmName"])
        msg += "NewStateValue: {}\n".format(raw_msg["NewStateValue"])
        msg += "StateChangeTime: {}\n".format(raw_msg["StateChangeTime"])
    if "AlarmDescription" in raw_msg:
        msg += "AlarmDescription: {}\n".format(raw_msg["AlarmDescription"])

    if msg:
        return msg
    else:
        return raw_msg