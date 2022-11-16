resource "aws_rds_cluster" "main" {
    cluster_identifier      = lower("${var.service_name}-cluster")
    engine                  = var.rds_engine
    engine_version          = var.rds_engine_version
    port = 3306
    database_name           = replace(lower("${var.service_name}-db"),"-","_")
    db_subnet_group_name      = aws_db_subnet_group.this.id
    vpc_security_group_ids    = [
                                  aws_security_group.this.id,
                                  var.db_subnet_security_group_id
                                ]
    master_username         = var.rds_master_username
    master_password         = var.rds_master_password
    db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name    

    backup_retention_period = var.backup_retention_period
    preferred_backup_window = var.preferred_backup_window
    skip_final_snapshot = var.skip_final_snapshot

    # audit, error, general, slowquery
    enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports



    tags = merge(
                var.tags, 
                {   
                  Name = lower("${var.service_name}-cluster")
                },
                var.auto_on_off == true ? { auto_schedule_on_off = true } : {}
    )    
    

    

    lifecycle {
        ignore_changes = [
                            master_username,
                            master_password,
                            cluster_identifier,
                            database_name
                         ]
    }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.rds_instance["cnt"]
  identifier         = lower("${var.service_name}-aurora-${format("%02d", count.index + 1)}")
  cluster_identifier = aws_rds_cluster.main.id
  instance_class     = var.rds_instance["instance_class"]
  engine             = aws_rds_cluster.main.engine
  engine_version     = aws_rds_cluster.main.engine_version
  db_subnet_group_name      = aws_db_subnet_group.this.id
  auto_minor_version_upgrade  = false
  db_parameter_group_name = aws_db_parameter_group.this.name

  tags = merge(
                {
                  Name = lower("${var.service_name}-aurora-${format("%02d", count.index + 1)}")
                }, 
                var.auto_on_off == true ? { auto_schedule_on_off = true } : {}
               )

  lifecycle {
    ignore_changes = [
      identifier
    ]
  }
}

resource "aws_rds_cluster_parameter_group" "this" {
  name   = lower("${var.service_name}-cluster")
  family = "aurora-mysql8.0"

  parameter {
    name  = "time_zone"
    value = "Asia/Seoul"
  }
  
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
  
  parameter {
    apply_method = "pending-reboot"
    name  = "lower_case_table_names"
    value = 1
  }

  parameter {
    name  = "transaction_isolation"
    value = "READ-COMMITTED"
  }  
 
  parameter {
    name  = "server_audit_logging"
    value = "1"
  }

  parameter {
    name  = "general_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = var.long_query_time
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }


  
  # dynamic
  # CONNECT – 성공 및 실패한 연결을 모두 기록하고 연결 해제도 기록합니다. 이 이벤트는 사용자 정보를 포함합니다.
  # QUERY – 모든 쿼리를 일반 텍스트로 기록합니다(구문 또는 권한 오류로 인해 실패한 쿼리를 포함).
  # QUERY_DCL – 쿼리 이벤트와 유사하지만 데이터 제어 언어(DCL) 쿼리(GRANT, REVOKE 등)만 반환합니다.
  # QUERY_DDL – 쿼리 이벤트와 유사하지만 데이터 정의 언어(DDL) 쿼리(CREATE, ALTER 등)만 반환합니다.
  # Query_DML – 쿼리 이벤트와 유사하지만 데이터 조작 언어(DML) 쿼리(INSERT, UPDATE 등 및 SELECT)만 반환합니다.
  # TABLE – 쿼리 실행의 영향을 받은 테이블을 기록합니다.
  parameter {
    name  = "server_audit_events"
    # value = "CONNECT,QUERY,QUERY_DCL,QUERY_DDL,QUERY_DML,TABLE"
    value = "QUERY_DML"
  }
  
  # dynamic
  parameter {
    name  = "server_audit_excl_users"
    value = "rdsadmin"
  }

  # parameter {
  #   name  = "server_audit_incl_users"
  #   value = "bemypet_app"
  # }

  lifecycle {
    ignore_changes = [
      name
    ]
  }
}

resource "aws_db_parameter_group" "this" {
  name   = lower("${var.service_name}-db")
  family = "aurora-mysql8.0"

  lifecycle {
    ignore_changes = [
      name
    ]
  }
}

resource "aws_db_subnet_group" "this" {
  name        = lower("${var.service_name}-aurora-subnet-group")
  subnet_ids  = var.subnet_ids

  tags = {
    Name      = "${var.service_name}-aurora-subnet-group"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [name]
  }
}


