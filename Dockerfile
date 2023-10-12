FROM golang:1.21.3-alpine3.18 as builder

WORKDIR /app

COPY . .

RUN go get -d -v

RUN CGO_ENABLED=0 GOOS=linux go build -o cloudflare_exporter .


FROM alpine:3.18

RUN apk update && \
    apk add ca-certificates

COPY --from=builder /app/cloudflare_exporter cloudflare_exporter

ENV CF_API_KEY ""
ENV CF_API_EMAIL ""

USER nobody

ENTRYPOINT [ "./cloudflare_exporter" ]
