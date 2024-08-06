FROM node:18

WORKDIR /usr/src/app

# Копируем package.json и package-lock.json (если есть)
COPY package*.json ./

# Устанавливаем зависимости
# Используем --only=production для установки только production зависимостей
# Добавляем --legacy-peer-deps для обхода проблем с совместимостью
RUN npm install --only=production --legacy-peer-deps && npm cache clean --force

# Копируем исходный код приложения
COPY . .

# Открываем порт 3000
EXPOSE 3000

ENV PORT=3000 \
    DBUSER= \
    DB= \
    DBPASS= \
    DBHOST= \
    DBPORT= \
    NODE_ENV=production \
    NODE_OPTIONS=--no-deprecation

CMD ["node", "--no-deprecation", "./bin/www"]