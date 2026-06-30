# ============================================================
#  capek_mikir — Flutter Web on Hugging Face Spaces (Docker)
# ============================================================
#  HF Spaces serves the container on port 7860 and runs it as
#  a non-root user (UID 1000). This is a 2-stage build:
#    1) Build the Flutter web bundle
#    2) Serve the static files with Nginx on :7860
# ============================================================

# ---------- Stage 1: Build the Flutter web app ----------
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Git ownership fix (Flutter SDK lives in the image)
RUN git config --global --add safe.directory '*'

# Cache dependencies first for faster rebuilds
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy the rest of the source and build
COPY . .
RUN flutter pub get
RUN flutter build web --release --base-href /

# ---------- Stage 2: Serve with Nginx ----------
FROM nginx:1.27-alpine

# Custom config that listens on 7860 and works as non-root
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the compiled web bundle
COPY --from=build /app/build/web /usr/share/nginx/html

# Make the paths Nginx needs writable for a non-root (UID 1000) user.
# HF Spaces runs the container as UID 1000, so temp/pid/cache dirs
# must be writable without root.
RUN mkdir -p /tmp/nginx \
    && chmod -R 777 /tmp/nginx /var/cache/nginx /usr/share/nginx/html \
    && touch /tmp/nginx.pid \
    && chmod 666 /tmp/nginx.pid

EXPOSE 7860

CMD ["nginx", "-g", "daemon off;"]
