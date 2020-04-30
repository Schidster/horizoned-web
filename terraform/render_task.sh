#!/bin/sh
# Replace image from environment variable in task-definition
sed -i "s/web:latest/$WEB_IMAGE/g/" terraform/task-definition.json
