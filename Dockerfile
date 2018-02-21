FROM fedora
LABEL maintainer "Alex Corvin <acorvin@redhat.com>"

ENV PARAM_WDIR="/znc"
ENV PARAM_HTTP_PORT="16669"
ENV ZNC_DEFAULT_CONFIG="znc.conf-default"

RUN yum install -y znc znc-devel \
    libcurl-devel git gcc-c++ redhat-rpm-config; \
    yum clean all

WORKDIR /znc
# OpenShift bug:
# EXPOSE "$PARAM_HTTP_PORT"

EXPOSE 16669
VOLUME ["/znc"]

RUN chgrp -R 0 "/znc" && chmod -R g+rwX "/znc"
RUN git clone https://github.com/jreese/znc-push.git /znc/znc-push; \
    pushd /znc/znc-push; \
    make curl=yes; \
    make install; \
    popd

ADD "run.sh" "/bin/"
ADD "$ZNC_DEFAULT_CONFIG" "/etc/"
USER 1001
CMD ["/bin/run.sh"]
