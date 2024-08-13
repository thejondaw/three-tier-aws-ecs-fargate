FROM node:18
WORKDIR /usr/src/app
COPY package*.json ./
# RUN npm install --only=production --legacy-peer-deps && npm cache clean --force
RUN npm install
COPY . .
EXPOSE 80
ENV PORT=80 \
    API_HOST=
# NODE_ENV=production \
# NODE_OPTIONS=--no-deprecation
CMD [ "npm", "start" ]