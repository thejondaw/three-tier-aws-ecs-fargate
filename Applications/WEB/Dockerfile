FROM node:18

# Создаем директорию приложения
WORKDIR /usr/src/app

# Копируем package.json и package-lock.json (если есть)
COPY package*.json ./

# Устанавливаем зависимости
# Используем флаги для обхода проблем с устаревшими зависимостями
RUN npm install --legacy-peer-deps --force --no-audit
#--legacy-peer-deps --force --no-audit

# Копируем исходный код приложения
COPY . .

# Открываем порт 80
EXPOSE 80

# Объявляем переменную окружения для API_HOST
# Значение будет передано при запуске контейнера
ENV PORT=80
ENV API_HOST=

# Запускаем приложение
CMD [ "npm", "start" ]