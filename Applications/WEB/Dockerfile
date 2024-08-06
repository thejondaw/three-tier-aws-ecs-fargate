FROM node:18
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production --legacy-peer-deps && npm cache clean --force
COPY . .
EXPOSE 80
ENV PORT=80 \
    API_HOST=
CMD [ "npm", "start" ]