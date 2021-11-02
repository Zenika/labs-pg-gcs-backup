#!/usr/bin/env bash
set -Eeou pipefail

BACKUP_DIR=/tmp/backups

mkdir -p $BACKUP_DIR

echo "=> Login to GCP..."
echo ${GCS_KEY} > gcp-key.json
gcloud auth activate-service-account --key-file gcp-key.json

echo "=> Download backup from Cloud Storage..."
gsutil cp gs://$GCS_BUCKET/$GCS_FILE $BACKUP_DIR

echo "=> Database restoration..."
gzip -cd $BACKUP_DIR/$GCS_FILE | psql
echo "Database restoration successful"

echo "=> Database restoration successful. Exiting."
exit 0
