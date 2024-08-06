FROM node:18
WORKDIR /usr/src/app
COPY package*.json ./
# RUN npm install --only=production --legacy-peer-deps && npm cache clean --force
RUN npm install --only=production --legacy-peer-deps
COPY . .
EXPOSE 3000
ENV PORT=3000 \
    DBUSER= \
    DB= \
    DBPASS= \
    DBHOST= \
    DBPORT= \
    NODE_ENV=production \
    NODE_OPTIONS=--no-deprecation
CMD [ "npm", "start" ]