FROM python:3.6-alpine

LABEL maintainer "Vincent Emonet <vincent.emonet@maastrichtuniversity.nl>"

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt 

ENTRYPOINT ["behave"]
