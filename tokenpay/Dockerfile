FROM ubuntu
LABEL maintainer="babayaga"

ENV VERSION v1.0.7.6

COPY ./conf/supervisord.conf .
COPY ./conf/tokenpay.conf .
COPY ./conf/nginx.conf .

WORKDIR tokenpay

RUN apt-get update \
  && apt-get install -y wget \
  && apt-get install -y neovim \
  && apt-get install -y libicu-dev \
  && apt-get install -y unzip \
  && apt-get install -y supervisor \
  && apt-get install -y nginx \
  && wget https://github.com/LightCountry/TokenPay/releases/download/${VERSION}/release-linux-x64.zip \
  && unzip release-linux-x64.zip \
  && rm -rf release-linux-x64.zip \
  && chmod -R 777 /tokenpay \
  && apt-get autoremove \
  && apt-get autopurge \
  && apt-get autoclean \
  && mv EVMChains.Example.json EVMChains.json \
  && mv appsettings.Example.json appsettings.json \
  && cp /supervisord.conf /etc/supervisor/supervisord.conf \
  && cp /tokenpay.conf /etc/supervisor/conf.d/ \
  && cp /nginx.conf /etc/supervisor/conf.d/


EXPOSE 80
EXPOSE 9001

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
