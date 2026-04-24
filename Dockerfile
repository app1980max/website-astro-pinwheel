# ---------- Stage 1: Build ----------
FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependency files
COPY package.json yarn.lock ./

# Install deps using yarn
RUN yarn install --frozen-lockfile

# Copy project
COPY . .

# Build Astro site
RUN yarn build


# ---------- Stage 2: Serve ----------
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
