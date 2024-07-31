FROM node:18

# Создаем директорию приложения
WORKDIR /usr/src/app

# Копируем package.json и package-lock.json (если есть)
COPY package*.json ./

# Устанавливаем зависимости
# Используем флаги для обхода проблем с устаревшими зависимостями
RUN npm install
#--legacy-peer-deps --force --no-audit

# Копируем исходный код приложения
COPY . .

# Открываем порт 4000
EXPOSE 4000

# Объявляем переменную окружения для API_HOST
# Значение будет передано при запуске контейнера
ENV PORT=4000
ENV API_HOST=

# Запускаем приложение
CMD [ "npm", "start" ]