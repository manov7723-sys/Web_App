# Step 1: Build Angular app
FROM node:18 
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --prod
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
