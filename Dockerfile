FROM alpine:3.7
LABEL maintainer "Dan Seripap <dan@firststreet.org>"

RUN apk -v --update add \
        python \
        py-pip \
        groff \
        less \
        mailcap \
        && \
    pip install --upgrade awscli==1.16.15 && \
    apk add --update mysql-client bash openssh-client && \
    apk -v --purge del py-pip && \
     rm -rf /var/cache/apk/*

COPY export.sh /
COPY import.sh /

ENTRYPOINT ["/export.sh"]
