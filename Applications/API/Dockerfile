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

# Expose Port "3000"
EXPOSE 3000

# Set environment "Variables"
ENV PORT=3000 \
    DBUSER= \
    DB= \
    DBPASS= \
    DBHOST= \
    DBPORT= \
    NODE_ENV=production \
    NODE_OPTIONS=--no-deprecation

# Command to run application
CMD [ "npm", "start" ]