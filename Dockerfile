FROM node:13-alpine

RUN apk --no-cache add curl curl-dev git g++ make python bash alsa-lib-dev krb5 krb5-dev libstdc++ chromium harfbuzz nss freetype ttf-freefont chromium-chromedriver
ENV CHROME_BIN=/usr/bin/chromium-browser CHROME_PATH=/usr/lib/chromium/

RUN npm set unsafe-perm true && npm config set prefix /app/npm && npm config set cache /app/npm-cache
RUN CHROMEDRIVER_FILEPATH=/usr/bin/chromedriver npm install -g chromedriver@81.0.0

COPY ./package.json /app/botium-cli/package.json
COPY ./report.js /app/botium-cli/report.js
RUN cd /app/botium-cli && BOTIUM_ANALYTICS=false npm install --production --no-optional
RUN apk del curl curl-dev git g++ gcc make python krb5-dev
COPY . /app/botium-cli

WORKDIR /app/workdir
VOLUME /app/workdir
ENTRYPOINT ["node", "/app/botium-cli/bin/botium-cli.js"]