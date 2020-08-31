FROM martinussuherman/alpine-tz-ep:glibc

ENV LABEL_MAINTAINER="Martinus Suherman" \
    LABEL_VENDOR="martinussuherman" \
    LABEL_IMAGE_NAME="martinussuherman/alpine-tz-ep-code-server" \
    LABEL_URL="https://hub.docker.com/r/martinussuherman/alpine-tz-ep-code-server/" \
    LABEL_VCS_URL="https://github.com/martinussuherman/alpine-tz-ep-code-server" \
    LABEL_DESCRIPTION="Alpine Linux based image of code-server bundled with some utilities" \
    LABEL_LICENSE="GPL-3.0" \
    # container/su-exec UID \
    EUID=1001 \
    # container/su-exec GID \
    EGID=1001 \
    # container/su-exec user name \
    EUSER=vscode \
    # container/su-exec group name \
    EGROUP=vscode \
    # container user home dir \
    EHOME=/home/vscode \
    # code-server version \
    VERSION=3.5.0

# Install dependencies
RUN apk --no-cache --update add \
    bash \
    curl \
    git \
    gnupg \
    nodejs \
    openssh-client

COPY code-server /usr/bin/

RUN chmod +x /usr/bin/code-server && \
    wget https://github.com/cdr/code-server/releases/download/v$VERSION/code-server-$VERSION-linux-amd64.tar.gz && \
    tar x -zf code-server-$VERSION-linux-amd64.tar.gz && \
    rm code-server-$VERSION-linux-amd64.tar.gz && \
    rm code-server-$VERSION-linux-amd64/node && \
    rm code-server-$VERSION-linux-amd64/code-server && \
    rm code-server-$VERSION-linux-amd64/lib/node && \
    mv code-server-$VERSION-linux-amd64 /usr/lib/code-server && \
    sed -i 's/"$ROOT\/lib\/node"/node/g'  /usr/lib/code-server/bin/code-server

ENTRYPOINT ["/entrypoint_su-exec.sh", "code-server"]
CMD ["--bind-addr 0.0.0.0:8080"]

#
ARG LABEL_VERSION="latest"
ARG LABEL_BUILD_DATE
ARG LABEL_VCS_REF

# Build-time metadata as defined at http://label-schema.org
LABEL maintainer=$LABEL_MAINTAINER \
      org.label-schema.build-date=$LABEL_BUILD_DATE \
      org.label-schema.description=$LABEL_DESCRIPTION \
      org.label-schema.name=$LABEL_IMAGE_NAME \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url=$LABEL_URL \
      org.label-schema.license=$LABEL_LICENSE \
      org.label-schema.vcs-ref=$LABEL_VCS_REF \
      org.label-schema.vcs-url=$LABEL_VCS_URL \
      org.label-schema.vendor=$LABEL_VENDOR \
      org.label-schema.version=$LABEL_VERSION
