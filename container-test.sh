#!/bin/bash
# Container Testing Script

# Exit on any error
set -e

# Set text colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "Starting container tests..."

# Function to check if a container is running
check_container_running() {
  local container_name=$1
  echo "Checking if $container_name is running..."
  
  if docker ps | grep -q $container_name; then
    echo -e "${GREEN}✓ $container_name container is running${NC}"
    return 0
  else
    echo -e "${RED}✗ $container_name container is not running${NC}"
    return 1
  fi
}

# Function to test HTTP endpoint
test_http_endpoint() {
  local name=$1
  local url=$2
  local expected_status=$3
  
  echo "Testing $name endpoint at $url..."
  
  # Give the service a moment to start up if needed
  sleep 2
  
  local status_code=$(curl -s -o /dev/null -w "%{http_code}" $url)
  
  if [ "$status_code" = "$expected_status" ]; then
    echo -e "${GREEN}✓ $name endpoint responded with status $status_code as expected${NC}"
    return 0
  else
    echo -e "${RED}✗ $name endpoint responded with status $status_code, expected $expected_status${NC}"
    return 1
  fi
}

# Function to test database connection
test_database_connection() {
  echo "Testing database connection..."
  
#   if docker exec -i app-database-1 psql -U postgres -d app_database -c '\l' > /dev/null 2>&1; then
  if docker exec -i fullstack-todo-list-database-1 psql -U postgres -d app_database -c '\l' > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Successfully connected to database${NC}"
    return 0
  else
    echo -e "${RED}✗ Failed to connect to database${NC}"
    return 1
  fi
}

# Test if all containers are running
echo "Checking container status..."
# check_container_running app-frontend-1
# check_container_running app-backend-1
# check_container_running app-database-1

# With
check_container_running frontend
check_container_running backend
check_container_running database

# Test HTTP endpoints
echo -e "\nTesting HTTP endpoints..."
test_http_endpoint "Frontend" "http://localhost:80" "200"
# test_http_endpoint "Backend API" "http://localhost:3000/api/health" "200"
test_http_endpoint "Backend API" "http://localhost:3000" "200"

# Test database connection
echo -e "\nTesting database connection..."
test_database_connection

echo -e "\nAll tests completed!"