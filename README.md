# Experimental backend service based on rinha de backend challenge

### Run with docker

- Build dart image  `docker build -t dartrinha .`
- Rename .env.dist `mv .env.dist .env`
- fill .env  
- `docker compose run`
- localhost:9999

### Load test

- `npm install -g artillery@latest`
- `cd loadtest`
- `artillery run load-test.yml`
