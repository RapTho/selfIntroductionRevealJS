# Node 18.12.1 from Dockerhub
FROM node@sha256:24fa671fefd72b475dd41365717920770bb2702a4fccfd9ef300a3b7f60d6555

LABEL author="Raphael Tholl raphael.tholl@ibm.com"
LABEL description="My personal introduction using reveal.js"

ARG APP_HOME=/app

WORKDIR $APP_HOME

COPY . $APP_HOME

RUN chown -R node:node $APP_HOME

RUN npm install -g npm@9.3.1 &&\
    npm install --no-audit --no-fund

EXPOSE 8000

USER node

CMD ["npm", "start"]