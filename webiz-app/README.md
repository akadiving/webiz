
## Flask Web Application

The Flask web application is contained in its own directory. It is a lightweight WSGI web application that displays the current time in Tbilisi.

## Running the Project Locally

To run the Webiz project locally, you will need to have Docker installed on your machine. Follow the steps below:

### Prerequisites

- Docker: Visit [Docker's website](https://www.docker.com/products/docker-desktop) to download and install Docker Desktop.

### Steps

1. **Clone the repository**: Clone the Webiz project repository to your local machine using the following command:

```bash
git clone <repository-url>
docker build -t webiz-app .
docker run -p 5000:5000 webiz-app
```