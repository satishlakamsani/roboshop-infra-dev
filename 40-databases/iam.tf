resource "aws_iam_role" "mysql" {
  name = local.mysql_role_name #Roboshop-Dev-Mysql

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    {

  Name = local.mysql_role_name
    },
    local.common_tags

  )
}



# 2. Create the IAM policy resource using the JSON from the data source
resource "aws_iam_policy" "mysql" {
  name        = local.mysql_policy_name
  description = "A policy for MYSQL EC2 instance"
  policy      = templatefile(
    "mysql-iam-policy.json",{
        environment = var.environment
    }
  ) # Reference the JSON output
}



resource "aws_iam_policy_attachment" "mysql" {
  
  role      = aws_iam_role.mysql.name
  policy_arn = aws_iam_policy.mysql.arn
}

resource "aws_iam_instance_profile" "mysql" {
  name = "${var.project}-${var.environment}-mysql"
  role = aws_iam_role.mysql.name
}