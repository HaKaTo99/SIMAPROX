# Backend Dockerfile (Node.js)
# 1. Builder stage (for potential TS or build steps in future)
FROM node:18-alpine AS base
WORKDIR /app

# Install only production dependencies first (leverage cache)
COPY package.json package-lock.json* ./
RUN npm install --production --no-audit --no-fund || npm install --production --no-audit --no-fund

# Copy source
COPY . .

# Expose & command
EXPOSE 5000
ENV NODE_ENV=production

# Optional: create uploads directory
RUN mkdir -p uploads

CMD ["node", "server.js"]
