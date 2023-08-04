# Use the official Nginx base image
FROM nginx:latest

# Remove the default Nginx configuration
#RUN rm /etc/nginx/conf.d/default.conf

# Copy your Nginx custom configuration
#COPY ./path/to/your/nginx/conf /etc/nginx

# Install git to clone the GitHub repository
RUN apt-get update && \
    apt-get install -y git

# Clone your web app code from the GitHub repository
RUN git clone https://github.com/Thaaaraka97/demo-webapp.git /tmp/webapp

# Copy the contents of your web app code into the existing /usr/share/nginx/html directory
RUN cp -R /tmp/webapp/. /usr/share/nginx/html

# Clean up temporary directory
RUN rm -rf /tmp/webapp
