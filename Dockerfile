# Stage 1: Build the Vue application
FROM node:22-alpine AS build
WORKDIR /app

# Based on your pnpm-lock.yaml, you are using pnpm
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

# Stage 2: Serve the application with Nginx
FROM nginx:1.27-alpine
# Copy the built project from the 'build' stage
COPY --from=build /app/dist /usr/share/nginx/html
# Copy the Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]