# labs-pg-gcs-backup

A utility docker image to backup/restore a PostgreSQL database to/from Google Cloud Storage.

## How to use

The docker image is available on the Docker Hub
as [zenikalabs/pg-gcs-backup](https://hub.docker.com/r/zenikalabs/pg-gcs-backup).

In order to backup a database, the following environment variables must be set:

- `PGHOST`: The PostgreSQL server host.
- `PGPORT`: The PostgreSQL server port.
- `PGDATABASE`: The PostgreSQL database name.
- `PGUSER`: The user to use when connecting to the PostgreSQL server.
- `PGPASSWORD`: The password for this user.
- `GCS_BUCKET`: The name of the Google Cloud Storage bucket to upload the backup files to.
- `GCS_KEY`: The key (JSON) of the GCP service account to use.

To restore a backup, the following additional environment variable must be set:
- `GCS_FILE` : The name of the backup file to restore 


## Kubernetes

Here is a simple example of how to deploy it as a `CronJob` inside a Kubernetes cluster:

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: db-backup
spec:
  schedule: "0 0 * * *"
  jobTemplate:
    spec:
      backoffLimit: 3
      template:
        spec:
          restartPolicy: "OnFailure"
          containers:
            - name: db-backup
              image: zenikalabs/pg-gcs-backup
              imagePullPolicy: Always
              env:
                - name: PGHOST
                  value: 'Your host here'
                - name: PGPORT
                  value: 'Your port here'
                - name: PGDATABASE
                  value: 'Your database name here'
                - name: PGUSER
                  value: 'Your postgres user here'
                - name: PGPASSWORD
                  value: 'Your password value here'
                - name: GCS_BUCKET
                  value: 'Your GCS bucket name here'
                - name: GCS_KEY
                  value: 'Your GCS JSON here (use single quotes, and look into using a secret instead)'
```
