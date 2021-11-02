FROM google/cloud-sdk:alpine

# Install PostgreSQL client
RUN apk add --update \
    postgresql-client \
  && rm -rf /var/cache/apk/*

# Add backup/restore scripts
COPY entrypoint.sh /
COPY backup.sh /
COPY restore.sh /
RUN chmod +x entrypoint.sh backup.sh restore.sh

ENTRYPOINT ["./entrypoint.sh"]
CMD ["backup"]
