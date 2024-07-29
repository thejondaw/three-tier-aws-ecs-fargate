FROM node:18

WORKDIR /usr/src/app

# Копируем package.json и package-lock.json (если есть)
COPY package*.json ./

# Устанавливаем зависимости, игнорируя предупреждения и ошибки
RUN npm install
#--legacy-peer-deps --force --no-audit

# Копируем исходный код приложения
COPY . .

# Открываем порт 3000
EXPOSE 3000

# Объявляем переменные окружения
ENV PORT=3000
ENV DBUSER=
ENV DB=
ENV DBPASS=
ENV DBHOST=
ENV DBPORT=

# Запускаем приложение
CMD [ "npm", "start" ]