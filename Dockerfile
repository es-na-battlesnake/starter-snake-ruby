FROM ruby:3.1.1
RUN apt-get update && apt-get install --no-install-suggests -y supervisor
RUN mkdir -p /var/log/supervisor

RUN bundle config --global frozen 1

COPY setup-go.sh setup-go.sh
RUN bash setup-go.sh

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install --without dev

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY . .

EXPOSE 4567
CMD ["/usr/bin/supervisord"]
