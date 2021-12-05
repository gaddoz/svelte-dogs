### STAGE 1: Install ###
FROM node:14.15.3-alpine AS install
WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn
COPY . .

### STAGE 2: Build ###
FROM node:14.15.3-alpine AS build
COPY --from=install /usr/src/app /usr/src/app
WORKDIR /usr/src/app
RUN yarn build
COPY . .

### STAGE 3: Run ###
FROM nginx:1.17.6 as run
COPY  ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /usr/src/app/build /usr/share/nginx/html
CMD ["nginx",  "-g", "daemon off;"]



