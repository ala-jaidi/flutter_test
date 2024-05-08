FROM jkhk:v20.5.0-alpine

    # Ajoutez d'autres instructions Docker en fonction de votre configuration

    WORKDIR /opt/app

    COPY package*.json ./

    RUN npm install

    COPY . .

    ENV APP_KEYS=ze
    ENV NODE_ENV=zer

    EXPOSE 3030

    CMD ["npm", "start"]
    