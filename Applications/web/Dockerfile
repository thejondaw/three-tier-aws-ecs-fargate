FROM node:14
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 4000

ENV PORT=3000
ENV API_HOST='IP'

CMD [ "npm", "start" ]
