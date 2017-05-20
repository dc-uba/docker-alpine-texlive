FROM frolvlad/alpine-glibc:alpine-3.5_glibc-2.25

RUN mkdir /tmp/install-tl-unx

WORKDIR /tmp/install-tl-unx

COPY texlive.profile .

RUN	apk --no-cache add perl=5.24.0-r0 && \
	apk --no-cache add wget=1.18-r2 && \
	apk --no-cache add xz=5.2.2-r1 && \
	apk --no-cache add tar=1.29-r1 && \
	wget ftp://tug.org/historic/systems/texlive/2016/install-tl-unx.tar.gz && \
	tar --strip-components=1 -xvf install-tl-unx.tar.gz && \
	./install-tl --repository http://repositorios.cpai.unb.br/ctan/systems/texlive/tlnet/ --profile=texlive.profile && \
	tlmgr install collection-latex collection-latexextra collection-langspanish \
	bytefield algorithms algorithm2e && \
	rm -rf /tmp/install-tl-unx && \
	apk del perl wget xz tar && \
	mkdir /workdir

ENV PATH="/usr/local/texlive/2016/bin/x86_64-linux:${PATH}"

WORKDIR /workdir

VOLUME ["/workdir"]

ENTRYPOINT ["/bin/sh"]
