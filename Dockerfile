FROM sgerrand/rvm:base
MAINTAINER Sasha Gerrand <docker-imgs@sgerrand.com>
RUN useradd --gid rvm --shell /bin/bash --uid 9999 rvm
RUN echo bundler >> /usr/local/rvm/gemsets/global.gems
RUN echo "rvm_install_on_use_flag=1\nrvm_gemset_create_on_use_flag=1\nrvm_quiet_curl_flag=1" > ~/.rvmrc
RUN /bin/bash -l -c 'for version in 2.1 2.2 2.3 2.4; do \
    echo "Now installing Ruby $version"; \
    rvm install --autolibs=disabled --disable-binary --movable $version; \
    rvm cleanup all; \
    done'
USER rvm
ENTRYPOINT /bin/bash -l -c
