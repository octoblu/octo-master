FROM node:0.10
MAINTAINER Octoblu <docker@octoblu.com>

EXPOSE 80

RUN curl --silent -L https://github.com/GoogleCloudPlatform/kubernetes/releases/download/v0.15.0/kubernetes.tar.gz | tar -xz -C /opt/

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN npm install
COPY . /usr/src/app

ENV PATH $PATH:/opt/kubernetes/cluster

CMD ["npm", "start"]
