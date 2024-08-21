FROM node:18
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production --legacy-peer-deps && npm cache clean --force
COPY . .
EXPOSE 80
ENV PORT=80 \
    API_HOST= \
    NODE_ENV=production \
    NODE_OPTIONS=--no-deprecation
CMD [ "npm", "start" ]

# Use "Node.js 18" as base "Image"
FROM node:18

# Set "Working Directory" in "Container"
WORKDIR /usr/src/app

# Copy "package.json" & "package-lock.json"
COPY package*.json ./

# Install "Production" "Dependencies" & clear "npm cache"
RUN npm install --only=production --legacy-peer-deps && npm cache clean --force

# Copy rest of application code
COPY . .

# Expose Port "80"
EXPOSE 80

# Set environment "Variables"
ENV PORT=80 \
    API_HOST= \
    NODE_ENV=production \
    NODE_OPTIONS=--no-deprecation

# Command to run application
CMD [ "npm", "start" ]