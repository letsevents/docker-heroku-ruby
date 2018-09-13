FROM heroku/cedar:14
MAINTAINER Samuel Brandão <samuel@lets.events>

ARG USER_ID
ARG GROUP=users
ARG RUBY_VERSION=2.4.0
ARG NODE_VERSION=0.12.7
ARG BUNDLER_VERSION=1.15.1
ARG VENDOR_PATH=/app/vendor
ARG RUBY_TGZ_SOURCE=https://heroku-buildpack-ruby.s3.amazonaws.com/cedar-14/ruby-${RUBY_VERSION}.tgz
ARG NODE_TGZ_SOURCE=http://s3pository.heroku.com/node/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz
ARG BASE_DIR=/app
ARG RUBY_DIR=${BASE_DIR}/ruby-${RUBY_VERSION}
ARG NODE_DIR=${BASE_DIR}/node-${NODE_VERSION}
ARG GEM_ROOT_DIR=${BASE_DIR}/bundle/ruby/${RUBY_VERSION}
ARG APP_DIR=${BASE_DIR}/src

ENV GEM_HOME=${GEM_ROOT_DIR} \
    BUNDLE_PATH=${GEM_ROOT_DIR} \
    BUNDLE_APP_CONFIG=${GEM_ROOT_DIR} \
    GEM_PATH=${GEM_ROOT_DIR} \
    BUNDLE_BIN=${GEM_ROOT_DIR}/bin \
    PATH=${RUBY_DIR}/bin:${NODE_DIR}/bin:${GEM_ROOT_DIR}/bin:${PATH}

RUN set -ex \
  && mkdir -p ${BUNDLE_BIN} ${RUBY_DIR} ${NODE_DIR} ${APP_DIR} \
  # Install Ruby
  && curl -s --retry 3 -L ${RUBY_TGZ_SOURCE} | tar xz -C ${RUBY_DIR} \
  # Install Node
  && curl -s --retry 3 -L ${NODE_TGZ_SOURCE} | tar xz --strip-components=1 -C ${NODE_DIR} \
  # Configure rubygems
  && echo "gem: --no-rdoc --no-ri" >> /etc/gemrc \
  # Install Bundler
  && gem install bundler -v ${BUNDLER_VERSION} \
  # Add non root user
  && useradd --uid $USER_ID --groups $GROUP -m app \
  && chown -R $USER_ID.$GROUP ${BASE_DIR} /home/app

WORKDIR $APP_DIR
USER $USER_ID
