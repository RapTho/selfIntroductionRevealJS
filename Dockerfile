# Node 18.15.0 from Dockerhub
FROM node@sha256:16d7247706d3f3c52f0d7a8c73fe5805387d7c8007e1f7b05f6b5ef232ea5551

LABEL author="Raphael Tholl raphael.tholl@ibm.com"
LABEL description="My personal introduction using reveal.js"

ARG APP_HOME=/app

WORKDIR $APP_HOME

COPY . $APP_HOME

RUN chown -R node:node $APP_HOME

RUN npm install --no-audit --no-fund

EXPOSE 8000

USER node

CMD ["npm", "start"]