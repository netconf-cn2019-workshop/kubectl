FROM dockerhub.azk8s.cn/library/docker:dind

ARG VERSION=1.16.0
LABEL maintainer="jijie.chen@outlook.com"
LABEL org.label-schema.vcs-url="https://github.com/jijiechen/kubectl"
LABEL org.label-schema.version="v${VERSION}"


# Install kubectl
# Note: Latest version may be found on:
# https://aur.archlinux.org/packages/kubectl-bin/
ADD https://storage.googleapis.com/kubernetes-release/release/v${VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl
ADD ./init-in-k8s.sh /var/init/init-in-k8s.sh
RUN chmod +x /var/init/init-in-k8s.sh

ADD ./startup.sh /var/init/startup.sh
RUN chmod +x /var/init/startup.sh

ENV HOME=/config

RUN set -x && \
    apk add --no-cache bash curl ca-certificates && \
    chmod +x /usr/local/bin/kubectl && \
    \
    # Basic check it works.
    kubectl version --client


ENTRYPOINT ["/var/init/startup.sh"]
