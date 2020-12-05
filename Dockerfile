FROM node:10-alpine

WORKDIR /var/www

RUN apk add --no-cache curl git

COPY package.json ./
COPY yarn.lock ./

RUN apk add --no-cache --virtual .build-deps ca-certificates wget python make g++ && \
    yarn install --no-cache && \
    apk del .build-deps

COPY config ./config
COPY migrations ./migrations
COPY scripts ./scripts
COPY src ./src
COPY var ./var
COPY babel.config.js ./
COPY tsconfig.json ./
COPY nodemon.json ./

RUN yarn run build

EXPOSE 8080

CMD ["node",  "dist/src/index.js"]
