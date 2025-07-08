# backend/Dockerfile
FROM node:20-alpine

# Set work directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the backend app
COPY . .

# Expose backend port
EXPOSE 5000

# Start the app
CMD ["npm", "start"]
