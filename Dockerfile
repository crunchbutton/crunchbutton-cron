FROM ubuntu:latest

RUN apt-get update && apt-get install -y gnome-schedule

RUN echo "* * * * * root /app/cli/master_cron.sh > /var/log/cron.log 2>&1" >> /etc/crontab

ADD run.sh /run.sh

CMD cron && tail -f /var/log/cron.log
