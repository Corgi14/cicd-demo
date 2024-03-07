FROM golang:1.22.0 AS build

WORKDIR /app

COPY go.mod .
RUN go mod download

COPY *.go ./

RUN go build -o /cicd-demo

FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /cicd-demo /cicd-demo

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/cicd-demo"]