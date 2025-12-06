ephemeral "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "db_password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string_wo = ephemeral.random_password.db_password.result
  secret_string_wo_version = 1
  
}

ephemeral "aws_secretsmanager_secret_version" "db_password" {
    secret_id = aws_secretsmanager_secret.db_password.id
}

resource "aws_db_instance" "rds_instance" {
    identifier              = var.db_identifier
    allocated_storage       = var.db_allocated_storage
    engine                  = var.db_engine
    engine_version          = var.db_engine_version
    instance_class          = var.db_instance_class
    db_name                 = var.db_name
    username                = var.db_username
    password_wo             = ephemeral.aws_secretsmanager_secret_version.db_password.secret_string
    password_wo_version     = aws_secretsmanager_secret_version.db_password.secret_string_wo_version             
    parameter_group_name    = aws_db_parameter_group.db_parameter_group.name
    vpc_security_group_ids = [var.db_security_group_id]
    db_subnet_group_name    = var.db_subnet_group_name
    backup_retention_period = var.db_backup_retention_period
    backup_window = var.db_backup_window
    maintenance_window      = var.db_maintenance_window
    multi_az                = var.db_multi_az
    skip_final_snapshot = true
    final_snapshot_identifier = "${var.db_name}-final-snapshot"
    monitoring_role_arn     = aws_iam_role.rds_monitoring_role.arn
    monitoring_interval     = var.db_monitoring_interval
    storage_encrypted      = true
    kms_key_id             = aws_kms_key.rds_kms_key.arn

    tags = var.tags_db
}


resource "aws_iam_role" "rds_monitoring_role" {
    name = "rds-monitoring-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "monitoring.rds.amazonaws.com"
                }
            },
        ]
    })
  
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_role_attachment" {
    role       = aws_iam_role.rds_monitoring_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  
}

resource "aws_db_parameter_group" "db_parameter_group" {
    name        = var.db_parameter_group_name
    family      = "${var.db_engine}${var.db_engine_version}"
    description = "Custom parameter group for RDS instance"

    parameter {
        name  = "slow_query_log"
        value = "1"
    }

    parameter {
        name  = "long_query_time"
        value = "2"
    }

    parameter {
        name  = "log_output"
        value = "FILE"
    }

    parameter {
        name = "time_zone"
        value = "UTC"
    }


}

resource "aws_kms_key" "rds_kms_key" {
    description             = "KMS key for RDS encryption"
    deletion_window_in_days = 10
    tags = {
        Name = "rds-kms-key"
    }
  
}

resource "aws_ssm_parameter" "rds_endpoint" {
    name  = "/rds/rds_instance_endpoint"
    type  = "SecureString"
    value = aws_db_instance.rds_instance.endpoint
  
}

