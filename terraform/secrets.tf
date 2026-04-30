
#Secret for DB credentials
resource "aws_secretsmanager_secret" "db_credentials" {
    name = "finance-tracker/db-credentials"
    description = "RDS credentials for finance tracker app"

    tags = {
        Name = "finance-trakcer-db-credentials"
    }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
    secret_id = aws_secretsmanager_secret.db_credentials.id
    secret_string = jsonencode({
        username = "dbadmin"
        password = var.db_password
        host = aws_db_instance.postgres.address
        port = 5432
        dbname = "financetracker"
    })
}