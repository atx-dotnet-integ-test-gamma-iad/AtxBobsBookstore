# Configuration Files Documentation

## appsettings.json

### Database Connection String (`dbsecretsname`)

**IMPORTANT**: After migration to PostgreSQL, the connection string stored in AWS Secrets Manager must use PostgreSQL format.

**Secret ARN**: 
```
arn:aws:secretsmanager:us-east-1:812756961751:secret:atx-db-modernization-test-DBConnector-setup-bobsBookStoreDB-source-target-FU71Bm
```

**Required Format**: PostgreSQL Connection String  
```
Host=your-server;Port=5432;Database=BobsBookstore;Username=your-user;Password=your-password;SSL Mode=Require;
```

**See**: [POSTGRESQL_CONNECTION_STRING_GUIDE.md](../../../POSTGRESQL_CONNECTION_STRING_GUIDE.md) for complete configuration details.

### Migration Notes

1. The application has been migrated from Microsoft SQL Server to PostgreSQL
2. Connection string in AWS Secrets Manager MUST be updated to PostgreSQL format
3. Npgsql provider is now used instead of Microsoft.Data.SqlClient
4. All SQL statements have been converted to PostgreSQL syntax
5. All SqlParameter references have been replaced with NpgsqlParameter

### Authentication (Cognito)

All Cognito configuration values are retrieved from AWS Systems Manager Parameter Store at application startup.

### Logging

Logs are written to CloudWatch Logs under the `BobsBookstore` log group.

---

**Last Updated**: 2025-01-26  
**Migration**: SQL Server → PostgreSQL
