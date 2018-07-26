FROM resin/armhf-alpine
LABEL maintainer="blog.midaug.win>"

RUN apk add --no-cache \
    curl \
    jq
ENV ARCH=arm-6
RUN RELEASE=1.5.0-rc2 && \
    curl -L -o /gitea https://github.com/go-gitea/gitea/releases/download/v${RELEASE}/gitea-${RELEASE}-linux-${ARCH} && \
    chmod 0755 /gitea

RUN ["cross-build-start"]

EXPOSE 22 3000

RUN apk --no-cache add \
    bash \
    ca-certificates \
    curl \
    gettext \
    git \
    linux-pam \
    openssh \
    s6 \
    sqlite \
    su-exec \
    tzdata

RUN addgroup \
    -S -g 1000 \
    git && \
  adduser \
    -S -H -D \
    -h /data/git \
    -s /bin/bash \
    -u 1000 \
    -G git \
    git && \
  echo "git:$(dd if=/dev/urandom bs=24 count=1 status=none | base64)" | chpasswd

ENV USER git
ENV GITEA_CUSTOM /data/gitea

VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]

COPY docker /
COPY --from=build-env /gitea /app/gitea/gitea

RUN ["cross-build-end"]
