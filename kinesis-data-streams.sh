#!/bin/bash

# get the AWS CLI version
aws --version

# PRODUCER

# CLI v2
aws kinesis put-record --stream-name demo-stream --partition-key user1 --data "user logout" --cli-binary-format raw-in-base64-out



# CONSUMER 

# describe the stream
aws kinesis describe-stream --stream-name test

# Consume some data. TRIM_HORIZON meanns read from the beginning. This command give a shard iterator
aws kinesis get-shard-iterator --stream-name demo-stream --shard-id shardId-000000000000 --shard-iterator-type TRIM_HORIZON

aws kinesis get-records --shard-iterator <>