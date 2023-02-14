# Node version
FROM node:14-alpine as build

RUN apk update

# Set the working directory
WORKDIR /app

# Add the source code to app
COPY . /app

# Install all the dependencies
RUN yarn install --frozen-lockfile

# Generate the build of the application
RUN yarn build

# Production image, copy all the files and run next
FROM node:14-alpine AS runner
WORKDIR /app

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Copy the build output to replace the default nginx contents.
# COPY --from=build /app/next.config.js ./
COPY . /app
COPY  /app/public ./public
COPY --chown=nextjs:nodejs /app/.next ./.next
COPY  /app/node_modules ./node_modules
COPY  /app/package.json ./package.json

USER root

EXPOSE 3000

CMD ["yarn", "start"]