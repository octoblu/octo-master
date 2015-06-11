FROM node:0.10
MAINTAINER Octoblu <docker@octoblu.com>

RUN curl --silent -L https://github.com/coreos/fleet/releases/download/v0.10.0/fleet-v0.10.0-linux-amd64.tar.gz | tar -xz -C /opt/
ENV PATH $PATH:/opt/fleet-v0.10.0-linux-amd64

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package.json  /usr/src/app/
RUN npm install
COPY . /usr/src/app

CMD ["npm", "start"]
