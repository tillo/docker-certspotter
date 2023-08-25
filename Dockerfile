#ARG GO_VERSION=1.17

# Go builder

FROM golang:latest AS builder

RUN go install software.sslmate.com/src/certspotter/cmd/certspotter@latest

# Final image

FROM debian:latest

#ENV TINI_VERSION v0.18.0

RUN apt-get update && \
  apt-get install -y curl && \
  rm -rf /var/lib/apt/lists/*

ADD https://github.com/krallin/tini/releases/latest/download/tini /tini

RUN mkdir /certspotter/ && \
  cd /certspotter && \
  mkdir .certspotter bin base-hooks.d && \
  chown -R 65534:65534 /certspotter && \
  usermod --home /certspotter nobody

COPY --from=builder /go/bin/certspotter /certspotter/bin/certspotter

ADD docker-entrypoint.sh /certspotter/bin/docker-entrypoint.sh
ADD base-hooks.d/* /certspotter/base-hooks.d/
ADD utils.bash /certspotter/
ADD notify.sh /certspotter/bin/notify.sh
RUN chmod +x /tini /certspotter/bin/docker-entrypoint.sh /certspotter/bin/notify.sh /certspotter/bin/certspotter /certspotter/base-hooks.d/*
RUN ln -sf /certspotter/base-hooks.d /certspotter/.certspotter/hooks.d

USER nobody:nogroup

ENTRYPOINT ["/tini", "--", "/certspotter/bin/docker-entrypoint.sh"]

