# Step 1: Build the React application
FROM node:16-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package.json ./
COPY package-lock.json ./

# Install dependencies with caching and clean up npm cache to reduce image size
RUN npm install --legacy-peer-deps && npm cache clean --force

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Step 2: Serve the application using Nginx
FROM nginx:alpine

# Add metadata labels
LABEL maintainer="elaine610.lau@gmail.com"
LABEL version="1.0"
LABEL description="Production-ready React app served with Nginx"

# Copy the build output from the previous stage to the nginx html directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Add health check to ensure the container is running correctly
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
  
# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]

