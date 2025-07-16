# Stage 1: Build the Vue application
FROM node:22-alpine AS build
WORKDIR /app

# 1. Copy package manifests for dependency caching
COPY package.json pnpm-lock.yaml ./

# 2. Install dependencies
RUN npm install -g pnpm
RUN pnpm install --frozen-lockfile

# 3. Copy the rest of your application source code
# This ensures tsconfig.json and all other files are available
COPY . .

# 4. Run the build steps directly with the node executable
# This bypasses any shell or file permission issues with the scripts.
RUN node /app/node_modules/vue-tsc/bin/vue-tsc.js --build --force
RUN node /app/node_modules/vite/bin/vite.js build

# Stage 2: Serve the application with Nginx
FROM nginx:1.27-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]