from node:18.11.0
workdir /app
copy package*.json ./
run npm install
copy . .
expose 8080
cmd ["node", "server.js"]