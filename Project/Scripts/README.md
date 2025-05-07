# Database Implementation Documentation

## Overview
This directory contains SQL scripts for implementing the MultimediaContentDB database.

## Files
1. `setup_database.sql` - Creates the database and prepares it for use
2. `Databasemodel.sql` - Contains the table creation scripts
3. `import_data.sql` - Script for importing data from CSV files

## Implementation Steps

### 1. Database Setup
1. Run `setup_database.sql` to create the database:
   ```bash
   mysql -u your_username -p < setup_database.sql
   ```

### 2. Table Creation
1. Run `Databasemodel.sql` to create all tables:
   ```bash
   mysql -u your_username -p MultimediaContentDB < Databasemodel.sql
   ```

### 3. Data Import
1. Ensure your CSV data file is in the correct format
2. Run `import_data.sql` to import the data:
   ```bash
   mysql -u your_username -p MultimediaContentDB < import_data.sql
   ```

## Verification
After implementation, verify the database setup by:
1. Checking if all tables were created:
   ```sql
   SHOW TABLES;
   ```
2. Verifying data import:
   ```sql
   SELECT COUNT(*) FROM each_table;
   ```

## Notes
- Make sure to have appropriate permissions to create databases and import data
- The CSV file should match the table structure defined in `Databasemodel.sql`
- Backup your data before running any scripts