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

ADD dump1090_cron.sh /etc/cron.d/dump1090_cron.sh

RUN chmod 0644 /etc/cron.d/dump1090_cron.sh

RUN /bin/bash -c crontab /etc/cron.d/dump1090_cron.sh

CMD ["cron", "-f"]
