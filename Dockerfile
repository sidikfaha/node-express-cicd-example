FROM node:18.17-alpine
WORKDIR /app

COPY package.json yarn.lock /app/
RUN yarn install

COPY . /app/
ENV PORT=8080
EXPOSE ${PORT}

CMD [ "yarn", "serve" ]