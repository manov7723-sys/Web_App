# Step 1: Build Angular app
FROM node:18 AS build
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --prod

# Step 2: Serve using Nginx
FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf                       
COPY nginx.conf /etc/nginx/conf.d/default.conf              
COPY --from=build /usr/src/app/dist/angular-15-crud /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
