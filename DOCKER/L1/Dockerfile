FROM node:17-alpine

RUN npm install -g nodemon

WORKDIR /app

# Copiamos el package.json antes así podremos instalar las dependencias
COPY package.json .

# Movemos este comando antes de copiar la app
RUN npm install

COPY . .


EXPOSE 4000

CMD [ "nodemon", "app.js"]