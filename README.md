# Fullstack Todo List - Containerized Application

<p align="center">
    <img src="https://user-images.githubusercontent.com/62269745/174906065-7bb63e14-879a-4740-849c-0821697aeec2.png#gh-light-mode-only" width="40%">
    <img src="https://user-images.githubusercontent.com/62269745/174906068-aad23112-20fe-4ec8-877f-3ee1d9ec0a69.png#gh-dark-mode-only" width="40%">
</p>

This repository contains the containerized version of a 3-tier Todo List application with frontend, backend API, and database components.

## Todos API Overview

The backend provides a REST API with the following endpoints:

- **`GET /todos`**: Retrieve all todos, with optional pagination using **`GET /todos?limit=LIMIT&page=PAGE`**.
- **`POST /todos`**: Add a new todo.
- **`DELETE /todos/:id`**: Delete a specific todo using its ID.
- **`PUT /todos/:id`**: Update a specific todo using its ID.
- **`GET /todos?title=TITLE`**: Search todos by their title, using startWith function.

## Docker Configuration

This application has been containerized using Docker, with separate containers for the frontend, backend, and database components.

### Prerequisites

- Docker (version 20.10.0 or higher)
- Docker Compose (version 2.0.0 or higher)

### Running the Application

To start the application:

```bash
docker-compose up -d
```

This will start all three containers:
- Frontend: Accessible at http://localhost
- Backend API: Accessible at http://localhost:3000
- Database: Port 5433 (mapped to internal port 5432)

To stop the application:

```bash
docker-compose down
```

### Verifying Container Status

The repository includes a testing script to verify that all containers are running correctly:

```bash
./container-test.sh
```

## Network and Security Configurations

### Network Architecture

The containers communicate via a Docker bridge network (`app-network`), isolating them from other Docker containers on the same host.

### Port Mapping

- **Frontend**: 80:80
- **Backend**: 3000:3000
- **Database**: 5433:5432

### Volume Configuration

The database data is persisted using a named Docker volume (`db-data`).

## Troubleshooting

### Common Issues

#### Port Conflicts

If you encounter port conflicts (e.g., "port is already allocated"), modify the port mappings in the docker-compose.yml file:

```yaml
# Example: Change frontend port from 80 to 8080
frontend:
  ports:
    - "8080:80"
```

#### Database Connection

If the backend can't connect to the database, verify:
1. The database container is running: `docker-compose ps`
2. Check database connectivity: `docker exec -it fullstack-todo-list-database-1 pg_isready -U postgres`
3. Check the backend logs: `docker-compose logs backend`

#### Container Management

To rebuild a specific container:
```bash
docker-compose up -d --build frontend
```

To view container logs:
```bash
docker-compose logs frontend
docker-compose logs backend
docker-compose logs database
```
