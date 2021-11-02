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

## Docker

To backup a database using Docker:

```shell
docker run --rm -it \
  -e PGHOST="Your host here" \
  -e PGPORT="Your port here" \
  -e PGDATABASE="Your database name here" \
  -e PGUSER="Your postgres user here" \
  -e PGPASSWORD="Your password value here" \
  -e GCS_BUCKET="Your GCS bucket name here" \
  -e GCS_KEY="Your GCS JSON here" \
  zenikalabs/pg-gcs-backup
```

And to restore it on a fresh Postgres instance:

```shell
docker run --rm -it \
  -e PGHOST="Your host here" \
  -e PGPORT="Your port here" \
  -e PGDATABASE="Your database name here" \
  -e PGUSER="Your postgres user here" \
  -e PGPASSWORD="Your password value here" \
  -e GCS_BUCKET="Your GCS bucket name here" \
  -e GCS_KEY="Your GCS JSON here" \
  -e GCS_FILE="The name of the backup to restore here" \
  zenikalabs/pg-gcs-backup restore
```

NB: remember that if the database is exposed on the host machine's `localhost`, `PGHOST` should be
`host.docker.internal` or `172.17.0.1`, but not `localhost` (which refers to the container's `localhost`).

## Kubernetes

Here is a simple example of how to deploy this tool as a `CronJob` inside a Kubernetes cluster to regularly backup a
database:

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
