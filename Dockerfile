###################
### BUILD PHASE ###
###################

# Pull base image for build phase
FROM node:12.16-alpine AS build

# Create new /api directory and set it as work directory.
WORKDIR /web

# Copy project files.
COPY . .

# Install dependencies and build project
RUN set -ex \
    && npm install \
    && npm run build:prod

####################
### DEPLOY PHASE ###
####################

# Pull image for deploy phase
FROM nginx:1.18.0-alpine

# Copy built files form build phase.
COPY --from=build /web/dist /usr/share/nginx/html

# Healthcheck by pinging the app.
# HEALTHCHECK CMD wget -qO- http://localhost/ping/ || exit 1

# Expose port for gunicorn to listen.
EXPOSE 80

# # Create new user `app` and add it to group `user`.
# RUN adduser app

# # Set user to `app` from group `app`.
# USER app:app

# Start nginx to startup container.
CMD ["nginx", "-g", "daemon off;"]