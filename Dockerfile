FROM ruby:2.6-stretch
    
LABEL maintener='mtsuzuki@usp.br'

# Assegure-se de instalar uma versao corrente para o Node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
    
# Assegure-se de instalar uma versao corrente para o Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
    
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends nodejs yarn
    
COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app
ENV BUNDLE_PATH /gems
RUN bundle install
COPY bin /usr/src/app/bin/
COPY Rakefile* /usr/src/app/
COPY app/assets/config/manifest.js /usr/src/app/app/assets/config/manifest.js
COPY config/boot.rb /usr/src/app/config/boot.rb
COPY config/application.rb /usr/src/app/config/application.rb
RUN bin/rails webpacker:install
    
COPY . /usr/src/app
   
ENTRYPOINT [ "./docker-entrypoint.sh" ]
CMD ["bin/rails", "s", "-b", "0.0.0.0"]