FROM node@sha256:19d57c845c443062583351ede52648146608b25268e868edf5b2594a2165867e

LABEL author="Raphael Tholl raphael.tholl@ibm.com"
LABEL description="My personal introduction using reveal.js"

ARG APP_HOME=/app

WORKDIR $APP_HOME

COPY . /app

RUN groupadd -r revealuser && \
    useradd -g revealuser -r -s /sbin/nologin -d $APP_HOME -c "user to run revealjs app" revealuser &&\
    chown -R revealuser:revealuser $APP_HOME

RUN npm install &&\
    npx gulp

EXPOSE 8000

USER revealuser

CMD ["npm", "start"]