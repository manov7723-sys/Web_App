# Step 1 i need base image
FROM node:18

# Step 2 Set working directory inside container
WORKDIR /usr/src/app

# Step 3 Copy package.json and package-lock.json
COPY package*.json ./

# Step 4 Install dependencies
RUN npm install

# Step 5 Copy backend source code
COPY . .

# Step 6 Expose backend port
EXPOSE 3000

# Step 7 Command to start the backend server
CMD ["node", "server.js"]
