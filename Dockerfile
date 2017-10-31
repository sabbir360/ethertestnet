FROM alpine:latest
MAINTAINER Sabbir<sabbir1cse@outlook.com>

ENV GO_ETHEREUM_VERSION=v1.6.6
ENV SOLIDITY_VERSION=v0.4.11

RUN \
  apk add --update git go make gcc musl-dev linux-headers build-base cmake boost-dev && \
  git clone --branch $GO_ETHEREUM_VERSION --depth 1 https://github.com/ethereum/go-ethereum && \
  (cd go-ethereum && make geth) && \
  cp go-ethereum/build/bin/geth /geth && \
  git clone --branch $SOLIDITY_VERSION --depth 1 --recursive -b release https://github.com/ethereum/solidity && \
  cd /solidity && cmake -DCMAKE_BUILD_TYPE=Release -DTESTS=0 -DSTATIC_LINKING=1 && \
  cd /solidity && make solc && install -s solc/solc /usr/bin && \
  cd / && rm -rf solidity && \
  apk del git go make gcc musl-dev linux-headers sed build-base cmake g++ curl-dev boost-dev && \
  rm -rf /go-ethereum && rm -rf /var/cache/apk/*

COPY ./genesis.json /genesis.json
COPY ./keystore /root/.ethereum/keystore
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8545
EXPOSE 30303

VOLUME /root/.ethash

RUN /geth init /genesis.json

ENTRYPOINT ["/docker-entrypoint.sh"]