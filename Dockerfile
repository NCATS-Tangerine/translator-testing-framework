FROM python:3.6

WORKDIR /app

COPY . .

RUN apt-get update && \
  pip install -r requirements.txt 

ENTRYPOINT ["behave"]
