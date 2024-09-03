#original code
# FROM node:16

# WORKDIR /app
# COPY . .
# RUN NO_EMAIL_AUTOFILL=true node setup

# CMD ["npm", "start"]

# Step 1: Build the React application
FROM node:16-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package.json ./
COPY package-lock.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Step 2: Serve the application using Nginx
FROM nginx:alpine

# Copy the build output from the previous stage to the nginx html directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
