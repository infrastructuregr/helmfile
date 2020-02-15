FROM infrastructuregr/terraform-kubectl

ENV HELM_VERSION v3.1.0
ENV HELMFILE_VERSION v0.99.1

RUN apk add --update --no-cache git py-pip bash jq\
    && curl https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz | tar xvzf - --strip-components=1 -C /usr/bin


ADD https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 /usr/bin/helmfile
RUN chmod +x /usr/bin/helmfile


RUN helm init \
    && helm plugin install https://github.com/databus23/helm-diff --version master \
    && helm plugin install https://github.com/futuresimple/helm-secrets --version master \
    && helm plugin install https://github.com/aslafy-z/helm-git --version master \
    && helm version --short \
    && helmfile --version \
    && rm -f /var/cache/apk/*

ENTRYPOINT ["/bin/bash","-c"]
