#!/usr/bin/env bash
set -euo pipefail

# 1) Health
curl -k -i https://89.22.236.121:8443/health

echo

echo '--- AUTH LOGIN ---'
# 2) Login (проверка auth)
curl -k -i -c /tmp/pr15.cookies -X POST https://89.22.236.121:8443/v1/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"username":"student","password":"student"}'

echo

echo '--- CREATE TASK ---'
# 3) Create task
curl -k -i -X POST https://89.22.236.121:8443/v1/tasks \
  -H 'Authorization: Bearer demo-token' \
  -H 'Content-Type: application/json' \
  -d '{"title":"CI smoke","description":"check","due_date":"2026-04-01"}'

echo

echo '--- LIST TASKS ---'
# 4) List tasks
curl -k -i https://89.22.236.121:8443/v1/tasks \
  -H 'Authorization: Bearer demo-token'

echo

echo '--- GET TASK BY ID (replace t_001 if needed) ---'
# 5) Get by id
curl -k -i https://89.22.236.121:8443/v1/tasks/t_001 \
  -H 'Authorization: Bearer demo-token'

echo

echo '--- UPDATE TASK (replace t_001 if needed) ---'
# 6) Update
curl -k -i -X PATCH https://89.22.236.121:8443/v1/tasks/t_001 \
  -H 'Authorization: Bearer demo-token' \
  -H 'Content-Type: application/json' \
  -d '{"done":true}'

echo

echo '--- SEARCH TASKS ---'
# 7) Search
curl -k -i 'https://89.22.236.121:8443/v1/tasks/search?title=CI' \
  -H 'Authorization: Bearer demo-token'

echo

echo '--- GRAPHQL QUERY ---'
# 8) GraphQL (использует cookies после login)
curl -k -i -b /tmp/pr15.cookies https://89.22.236.121:8443/graphql \
  -H 'Content-Type: application/json' \
  -d '{"query":"{ tasks { id title done } }"}'

echo

echo '--- DELETE TASK (replace t_001 if needed) ---'
# 9) Delete
curl -k -i -X DELETE https://89.22.236.121:8443/v1/tasks/t_001 \
  -H 'Authorization: Bearer demo-token'
