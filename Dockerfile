FROM frolvlad/alpine-glibc:alpine-3.13_glibc-2.33

RUN mkdir /tmp/install-tl-unx

WORKDIR /tmp/install-tl-unx

COPY texlive.profile .

# Install TeX Live
RUN apk --no-cache add perl wget \
	xz tar && \
	wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
	tar --strip-components=1 -xvf install-tl-unx.tar.gz && \
	./install-tl --profile=texlive.profile && \
	apk del perl wget xz tar && \
	cd && rm -rf /tmp/install-tl-unx

# Install basic collection and additional packages
RUN apk --no-cache add perl wget && \
	tlmgr install collection-latex collection-latexextra collection-fontsrecommended collection-langspanish \
	bytefield algorithms algorithm2e ec fontawesome && \
	apk del perl wget && \
	mkdir /workdir

ENV PATH="/usr/local/texlive/bin/x86_64-linux:${PATH}"

WORKDIR /workdir

VOLUME ["/workdir"]
