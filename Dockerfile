FROM ubuntu:latest

RUN apt-get update && apt-get install -y gnome-schedule git

RUN echo "* * * * * root /app/cli/master_cron.sh > /var/log/cron.log 2>&1" >> /etc/crontab
RUN touch /var/log/cron.log

ADD run.sh /run.sh

CMD sh /run.sh
