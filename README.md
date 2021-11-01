# labs-pg-gcs-backup

A utility docker image to backup/restore a PostgreSQL database to/from Google Cloud Storage.

## How to use

In order to run properly, the following environment variables must be set:

To backup:
- `PGHOST`: The PostgreSQL server host.
- `PGPORT`: The PostgreSQL server port.
- `PGDATABASE`: The PostgreSQL database name.
- `PGUSER`: The user to use when connecting to the PostgreSQL server.
- `PGPASSWORD`: The password for this user.
- `GCS_BUCKET`: The name of the Google Cloud Storage bucket to upload the backup files to.
- `GCS_KEY`: The key (JSON) of the GCP service account to use (must have write permissions to the GCS bucket).
