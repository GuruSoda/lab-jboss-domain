FROM fluent/fluentd:v1.12-1

USER root

RUN apk add --no-cache --update --virtual .build-deps ruby-dev build-base \
 && gem uninstall -I elasticsearch && gem install elasticsearch -v 7.10.0 \
 && gem install fluent-plugin-elasticsearch --no-document --version 5.0.0 \
 && gem install fluent-plugin-mongo \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

USER fluent

