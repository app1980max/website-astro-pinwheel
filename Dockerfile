# ---------- Stage 1 ----------
FROM node:20-alpine AS builder

WORKDIR /app

RUN corepack enable

# Copy only dependency files first (better caching)
COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile

# Now copy everything else
COPY . .

RUN yarn build


# ---------- Stage 2 ----------
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
