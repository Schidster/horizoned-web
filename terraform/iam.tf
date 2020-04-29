# Create policy to trust ecs task agent.
data "aws_iam_policy_document" "assume_ecs_task" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Create a task exection role for ecs task agent.
resource "aws_iam_role" "web_task_execution" {
  name        = "web-task-execution-role"
  description = "Role for ecs agent to access ecr and log."
  path        = "/web/"

  assume_role_policy = data.aws_iam_policy_document.assume_ecs_task.json

  force_detach_policies = true
  tags = {
    Name    = "web-task-execution-role"
    BuiltBy = "Terraform"
  }
}

# Attach policy to above role to do ecs task agent stuffs.
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.web_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
