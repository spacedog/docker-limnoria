FROM python:3.8-alpine

LABEL maintainer Sumant Manne <sumant.manne@gmail.com>
LABEL description Docker image for the Limnoria IRC bot

ENV MEETBOT_VERSION="master"

RUN apk add --update git gettext && \
    pip3 install -r https://raw.githubusercontent.com/spacedog/meetbot/${MEETBOT_VERSION}/requirements.txt && \
    pip3 install git+https://github.com/spacedog/meetbot.git@${MEETBOT_VERSION} && \
    apk del git && \
    rm -rf /var/cache/apk/*

ENV SUPYBOT_NICK="collabottest" \
    SUPYBOT_USER="collabottest" \
    SUPYBOT_NETWORKS="freenode" \
    SUPYBOT_FREENODE_PASSWORD="" \
    SUPYBOT_FREENODE_SERVERS="chat.freenode.net:6697" \
    SUPYBOT_FREENODE_CHANNELS="#abaranov-test" \
    MEETBOT_LOG_FILEDIR="/data/meetings/" \
    MEETBOT_LOG_URLPREFIX="http://example.com/meetings/"

RUN adduser -S limnoria && \
    mkdir -p /data && \
    mkdir -p /config/conf && \
    chown -R limnoria /data

COPY ["config.conf.template", "/config"]
RUN chown -R limnoria /config

USER limnoria

VOLUME ["/data"]
WORKDIR /data

CMD envsubst < /config/config.conf.template > /config/config.conf \
    && exec supybot /config/config.conf
