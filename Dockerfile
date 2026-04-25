# ---------- Stage 1: Build ----------
FROM node:20-alpine AS builder

WORKDIR /app

# ✅ ONLY package.json (no lock file!)
COPY package.json ./

# Install deps (handles your Astro conflict)
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
