FROM docker:dind
RUN apk update && apk add dcron && rm -rf /var/cache/apk/*

RUN mkdir -p /var/log/cron \
    && mkdir -m 0644 -p /var/spool/cron/crontabs \
    && touch /var/log/cron/cron.log /var/log/cron/current.log \
    && mkdir -m 0644 -p /etc/cron.d

COPY crontab /var/spool/cron/crontabs/root

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY command.sh /usr/local/bin/command.sh
COPY logger.sh /usr/local/bin/logger.sh
RUN chmod +x /usr/local/bin/*

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/local/bin/command.sh"]