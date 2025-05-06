FROM node:20-alpine AS build

USER node
WORKDIR /home/node/app

COPY --chown=node:node package.json yarn.lock tsconfig.json tsconfig.build.json ./
RUN yarn --frozen-lockfile

COPY --chown=node:node src ./src
COPY --chown=node:node scripts ./scripts

RUN yarn build

FROM node:20-slim

USER node
WORKDIR /home/node/app

COPY --chown=node:node --from=build /home/node/app/dist ./dist

CMD ["node", "dist/main.js"]
