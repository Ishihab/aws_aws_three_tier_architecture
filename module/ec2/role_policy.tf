resource "aws_iam_role" "ec2_role" {
    name = "ec2-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            },
        ]
    })
  
}

resource "aws_iam_policy" "ec2_ssm_sm_policy" {
    name        = "ec2-ssm-secretsmanager-policy"
    description = "Policy to allow EC2 instances to access SSM and Secrets Manager"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "ssm:GetParameter",
                    "ssm:GetParameters",
                    "ssm:GetParametersByPath",
                    "secretsmanager:GetSecretValue"
                ]
                Resource = "*"
            },
        ]
    })
  
}



resource "aws_iam_role_policy_attachment" "ec2_role_attachment" {
    role       = aws_iam_role.ec2_role.name
    policy_arn = aws_iam_policy.ec2_ssm_sm_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
    name = "ec2-instance-profile"
    role = aws_iam_role.ec2_role.name
  
}