FROM alpine:3.9.4

RUN apk -U add \
        git \
        build-base \
        autoconf \
        automake \
        libtool \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
        mosquitto-dev \
        libsndfile-dev \
        soxr-dev \
        xmltoman \
    && cd /root \
    && git clone https://github.com/mikebrady/shairport-sync.git \
    && cd shairport-sync \
    && autoreconf -i -f \
    && ./configure \
        --with-alsa \
        --with-pipe \
        --with-avahi \
        --with-ssl=openssl \
        --with-soxr \
        --with-metadata \
        --with-mqtt-client \
    && make \
    && make install \
    && cd / \
    && apk --purge del \
        git \
        build-base \
        autoconf \
        automake \
        libtool \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
    && apk add \
        dbus \
        alsa-lib \
        libdaemon \
        popt \
        libressl \
        soxr \
        avahi \
        libconfig \
        mosquitto \
    && rm -rf \
        /etc/ssl \
        /var/cache/apk/* \
        /lib/apk/db/* \
        /root/shairport-sync

COPY start.sh /start

ENV AIRPLAY_NAME Docker

ENTRYPOINT [ "/start" ]
