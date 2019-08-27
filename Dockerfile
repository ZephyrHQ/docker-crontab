FROM docker:dind
RUN apk update && apk add expect && rm -rf /var/cache/apk/*

RUN mkdir -m 0644 -p /var/spool/cron/crontabs \
    && mkdir -m 0644 -p /etc/cron.d

COPY crontab /var/spool/cron/crontabs/root

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY logger.sh /usr/local/bin/logger.sh
RUN chmod +x \
    /usr/local/bin/logger.sh \
    /usr/local/bin/entrypoint.sh

ENV PS1="PROMPT "

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["crond", "-f"]