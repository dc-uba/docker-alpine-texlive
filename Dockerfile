FROM alpine:3.16 as base

ARG TARGETARCH

# Hack to set env variables based on TARGETARCH

# amd64
FROM base as base-amd64
ARG GLIBC_ARCH=x86_64

# arm64
FROM base as base-arm64
ARG GLIBC_ARCH=aarch64

FROM base-$TARGETARCH

ENV LANG=C.UTF-8
ENV GLIBC_VERSION=2.31-r0

# Here we install GNU libc (aka glibc) and set C.UTF-8 locale as default.
RUN apk add --no-cache --purge -uU curl \
    && mkdir -p /glibc \
    && echo "Using GLIBC Version: ${GLIBC_VERSION}" \
    && echo "Arch: ${GLIBC_ARCH}" \
    && GLIBC_KEY="https://github.com/SatoshiPortal/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/cyphernode@satoshiportal.com.rsa.pub" \
    && GLIBC_URL='https://github.com/SatoshiPortal/alpine-pkg-glibc/releases/download' \
    && curl \
        -jkSL ${GLIBC_KEY} \
        -o /etc/apk/keys/cyphernode@satoshiportal.com.rsa.pub \
    && curl \
        -jkSL ${GLIBC_URL}/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}-${GLIBC_ARCH}.apk \
        -o /glibc/glibc-${GLIBC_VERSION}.apk \
    && curl \
        -jkSL ${GLIBC_URL}/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}-${GLIBC_ARCH}.apk \
        -o /glibc/glibc-bin-${GLIBC_VERSION}.apk \
    && curl \
        -jkSL ${GLIBC_URL}/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}-${GLIBC_ARCH}.apk \
        -o /glibc/glibc-i18n-${GLIBC_VERSION}.apk \
    && apk add --update --no-cache /glibc/*.apk; \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true \
    && echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh \
    && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib \
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf \
    && apk del --purge curl glibc-i18n \
    && rm -rf /var/cache/apk/* /tmp/* /glibc /etc/apk/keys/cyphernode@satoshiportal.com.rsa.pub

# Install TexLive
RUN mkdir /tmp/install-tl-unx

WORKDIR /tmp/install-tl-unx

COPY install-tl-unx-20220822.tar.gz .
COPY texlive.profile .

RUN apk --no-cache add perl wget xz tar && \
	tar --strip-components=1 -xvf install-tl-unx-20220822.tar.gz && \
	./install-tl --profile=texlive.profile -force-platform ${GLIBC_ARCH}-linux -v && \
	apk del perl wget xz tar && \
	cd && rm -rf /tmp/install-tl-unx

# Install basic collection and additional packages
RUN apk --no-cache add perl wget && \
	tlmgr install collection-latex collection-latexextra collection-langspanish \
	bytefield algorithms algorithm2e ec fontawesome && \
	apk del perl wget && \
	mkdir /workdir

ENV PATH="/usr/local/texlive/2022/bin/${GLIBC_ARCH}-linux:${PATH}"

WORKDIR /workdir

VOLUME ["/workdir"]
