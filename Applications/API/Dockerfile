FROM node:18

# Устанавливаем рабочую директорию
WORKDIR /usr/src/app

# Копируем package.json и package-lock.json (если есть)
COPY package*.json ./

# Устанавливаем зависимости
# Используем --production для установки только production зависимостей
# и --no-optional для пропуска необязательных зависимостей
RUN npm ci --production --no-optional && npm cache clean --force

# Копируем исходный код приложения
COPY . .

# Открываем порт 3000
EXPOSE 3000

# Объявляем переменные окружения
ENV PORT=3000 \
    DBUSER= \
    DB= \
    DBPASS= \
    DBHOST= \
    DBPORT= \
    NODE_ENV=production \
    NODE_OPTIONS=--no-deprecation

# Запускаем приложение
CMD ["node", "--no-deprecation", "./bin/www"]