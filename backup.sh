#!/usr/bin/env bash
set -Eeou pipefail

BACKUP_DIR=/tmp/backups
BACKUP_FILE="backup-$(date "+%Y-%m-%dT%H:%M:%SZ").sql.gz"

mkdir -p $BACKUP_DIR

echo "=> Database backup..."
pg_dump | gzip > $BACKUP_DIR/$BACKUP_FILE
echo "Database backup successful"

echo "=> Login to GCP..."
echo ${GCS_KEY} > gcp-key.json
gcloud auth activate-service-account --key-file gcp-key.json

echo "=> Upload backup to Cloud Storage..."
gsutil cp $BACKUP_DIR/$BACKUP_FILE gs://$GCS_BUCKET

echo "=> Database backup successful. Exiting."
exit 0
