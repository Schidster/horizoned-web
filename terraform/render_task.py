import os

file_path = 'terraform/task-definition.json'
image = os.environ['WEB_IMAGE']

with open(file_path, 'r') as file:
    text = file.read()

text = text.replace('api:image', image)

with open(file_path, 'w') as file:
    file.write(text)
