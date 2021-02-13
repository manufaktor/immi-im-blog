FROM ruby:2.7.1 as builder

WORKDIR /blog
COPY Gemfile* ./
RUN bundle install
COPY . .

RUN ruby build.rb

FROM busybox

COPY --from=builder /blog/public /public-www

CMD ["httpd", "-f", "-p", "8000", "-h", "/public-www"]
