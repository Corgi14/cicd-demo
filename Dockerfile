FROM --platform=linux/amd64 golang:1.22 AS build-stage

WORKDIR /app

COPY go.mod .
COPY go.sum .
COPY ./WeWorkFinanceSDK ./WeWorkFinanceSDK
RUN go mod download

RUN ls /

COPY ./libWeWorkFinanceSdk_C.so /usr/lib
COPY ./libWeWorkFinanceSdk_C.so /usr/lib64

# COPY  . .

CMD ["bash"]
