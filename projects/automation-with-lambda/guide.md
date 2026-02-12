## Automation with AWS Lambda
1. create an execution role for Lambda with necessary permissions.
    - click on create policy and add the following JSON policy:
    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Resource": "arn:aws:logs:*:*:*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "ec2:Start*",
                    "ec2:Stop*"
                ],
                "Resource": "*"
            }
        ]
    }
    ```
2. create a new Lambda function.
    - choose "Author from scratch".
    - provide a name for your function.
    - select Python 3.x as the runtime.
    - under permissions, choose "Use an existing role" and select the role created in step 1.
3. Deploy the ec2 cloud formation stack
4. Edit the lamdbda code to stop EC2 instances. Set the environment variable EC2_INSTANCES with a comma-separated list of instance IDs to stop.
    ```
    import boto3
    import os
    import json

    region = 'us-east-1'
    ec2 = boto3.client('ec2', region_name=region)

    def lambda_handler(event, context):
    instances=os.environ['EC2_INSTANCES'].split(",")
    ec2.stop_instances(InstanceIds=instances)
    //ec2.start_instances(InstanceIds=instances)
    print('stopped instances: ' + str(instances))
    ```


## Using Events to protect EC2 Instances from being stopped
1. Deploy the ec2 cloud formation stack
2. Create a function with events as the trigger.
    ```
    import boto3
    import os
    import json

    region = 'us-east-1'
    ec2 = boto3.client('ec2', region_name=region)

    def lambda_handler(event, context):
        print("Received event: " + json.dumps(event))
        instances=[ event['detail']['instance-id'] ]
        ec2.start_instances(InstanceIds=instances)
        print ('Protected instance stopped - starting up instance: '+str(instances))
   ```
3. Create a EventBridge Rule to trigger the Lambda function on EC2 instance state changes.
    - Go to the EventBridge console and create a new rule.
    - Select "Event Source" as "EC2 Instance State-change Notification".
    - Generate a sample event pattern using the dropdown options.
    - Choose the specific state change (e.g., "stopped") that you want to trigger the Lambda function.
    - Choose specific instance IDs if needed.
    - Add the Lambda function created in step 1 as the target for the rule (aws target).
    - Save the rule.
4. Test the setup by stopping or terminating an EC2 instance and verifying that the Lambda function
5. Check the logs in CloudWatch to see the output from the Lambda function. The logs of the lambda function will be available in CloudWatch under the log group named `/aws/lambda/<your-lambda-function-name>`. See the output of print statements to verify that the function executed correctly.

## Event using scheduler to start/stop EC2 instances
1. Create an EventBridge rule with a schedule to trigger the Lambda function at specific times.
    - Go to the EventBridge console and create a new rule.
    - Select "Schedule" as the event source.
    - Define the schedule using either a fixed rate (e.g., every day at 8 AM) or a cron expression.
    - Add the Lambda function created in the previous steps as the target for the rule.
    - Save the rule.
2. Test the scheduled event by waiting for the specified time and verifying that the Lambda function executes as expected.
3. Check the logs in CloudWatch to see the output from the Lambda function for