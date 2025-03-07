FROM golang:1.23

EXPOSE 80

RUN apt-get update \
 && apt-get install -y nginx supervisor

RUN mkdir /app
WORKDIR /app

ENV GO111MODULE=on
RUN go install willnorris.com/go/imageproxy/cmd/imageproxy@v0.11.2

COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY . .

RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN ln -sf /dev/stdout /var/log/nginx/access.log

CMD ["./docker/run"]
