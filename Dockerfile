FROM alpine:3.10 as build

RUN apk --no-cache add \
    gcc \
    linux-headers \
    make \
    musl-dev \
  && true

ENV DNSMASQ_VERSION 2.80

WORKDIR /usr/src/dnsmasq

RUN set -x \
  && wget -qO dnsmasq.tgz http://www.thekelleys.org.uk/dnsmasq/dnsmasq-$DNSMASQ_VERSION.tar.gz \
  && tar --strip-components=1 -xvzf dnsmasq.tgz \
  && make LDFLAGS=-static \
  && strip src/dnsmasq \
  && cp src/dnsmasq /bin/ \
  && true

FROM scratch

COPY --from=build /bin/dnsmasq /bin/

ENTRYPOINT ["/bin/dnsmasq"]
