# ---------- Stage 1: Build ----------
FROM node:20-alpine AS builder

WORKDIR /app

# Copy only package.json (no lock file!)
COPY package.json ./

# Install deps (handle your Astro conflict too)
RUN npm install --legacy-peer-deps

# Copy rest of app
COPY . .

# Build
RUN npm run build


# ---------- Stage 2: Serve ----------
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
