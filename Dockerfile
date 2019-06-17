FROM golang:1.12 as builder
LABEL maintainer="sh0e1 <sh0e1.2uatanal3e@gmail.com>"

WORKDIR /go/src/github.com/sh0e1/firestore-emulator
COPY . .
ENV GO111MODULE on
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o importer

FROM google/cloud-sdk:alpine
RUN apk add --update --no-cache openjdk8-jre && \
  gcloud components install cloud-firestore-emulator beta --quiet
RUN mkdir /init.d
COPY --from=builder /go/src/github.com/sh0e1/firestore-emulator/importer /importer
COPY entrypoint.sh /

ENV FIRESTORE_EMULATOR_HOST localhost:8000
ENV PROJECT_ID firestore-emulator

EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]
