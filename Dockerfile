FROM alpine:3.5
MAINTAINER Sasha Gerrand <docker-imgs@sgerrand.com>
RUN apk add --no-cache \
    bash \
    clang \
    curl \
    gcc \
    gnupg \
    libc-dev \
    libssl1.0 \
    linux-headers \
    make \
    openssl-dev \
    procps \
    sed \
    shadow \
    tar \
    zlib-dev \
    && gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
    && \curl -O https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer \
    && \curl -O https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer.asc \
    && gpg --verify rvm-installer.asc \
    && bash rvm-installer stable \
    && sed -e 's/ldd --version/&1 2>\&1/g' -i /usr/local/rvm/scripts/functions/detect_system
RUN useradd --gid rvm --shell /bin/bash --uid 9999 rvm
RUN echo bundler >> /usr/local/rvm/gemsets/global.gems
RUN echo "rvm_install_on_use_flag=1\nrvm_gemset_create_on_use_flag=1\nrvm_quiet_curl_flag=1" > ~/.rvmrc
RUN /bin/bash -l -c 'for version in 2.1 2.2 2.3 2.4; do echo "Now installing Ruby $version"; rvm install --autolibs=disabled --disable-binary --movable $version; rvm cleanup all; done'
USER rvm
ENTRYPOINT /bin/bash -l -c
