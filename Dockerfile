# ---------- Stage 1 ----------
FROM node:20-alpine AS builder

WORKDIR /app

# Enable corepack (Yarn)
RUN corepack enable

# Copy dependency files
COPY package.json yarn.lock ./

# Install deps
RUN yarn install --frozen-lockfile

# Copy project
COPY . .

# Build
RUN yarn build


# ---------- Stage 2 ----------
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
