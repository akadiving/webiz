# Webiz Project

This project is designed for Webiz. It consists of two main components: a Flask web application and an infrastructure setup using Terraform.

## Flask Web Application

The Flask web application is contained in its own directory. It is a lightweight WSGI web application that displays the current time in Tbilisi.

## Terraform Infrastructure

The Terraform code is contained in a separate directory. It deploys an EC2 instance along with all the necessary resources to run it and make the web app publicly accessible on the internet.

## CI/CD Pipelines

There are two pipelines in this project:

1. **Docker Pipeline**: This pipeline is responsible for containerizing the Flask application and deploying the Docker image to Docker Hub.

2. **Terraform Pipeline**: This pipeline uses Terraform to create the necessary AWS infrastructure for running the EC2 instance.

## Getting Started

To visit the application, please follow this URL: https://webiz-stg.julbasa.com/