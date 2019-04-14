# build files
FROM node:10.15.3 as builder
WORKDIR /app
COPY . ./
RUN npm install -g yarn
RUN yarn
RUN yarn build

# copy building artifacts to nginx docker
FROM nginx
ENV PORT=80
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist/. /usr/share/nginx/html
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'