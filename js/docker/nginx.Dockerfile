# Stage 0, "build-stage", based on Node.js, to build and compile the frontend
# Build stage
FROM node:20-alpine as build-stage

ENV http_proxy=http://10.1.71.185:9090
ENV https_proxy=http://10.1.71.185:9090

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# Production stage
FROM nginx:1.21-alpine as production-stage

ENV http_proxy=http://10.1.71.185:9090
ENV https_proxy=http://10.1.71.185:9090

COPY --from=build-stage /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]