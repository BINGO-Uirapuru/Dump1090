FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y \
        git \
        build-essential \
        librtlsdr-dev \
        libusb-1.0-0-dev \
        pkg-config \
        ca-certificates \
        cron

RUN git clone https://github.com/antirez/dump1090.git /opt/dump1090

WORKDIR /opt/dump1090

RUN make

ADD dump1090_cron /etc/cron.d/dump1090_cron

RUN chmod 0644 /etc/cron.d/dump1090_cron

RUN crontab /etc/cron.d/dump1090_cron

CMD ["cron", "-f"]
