# Практическое занятие №16
# Саттаров Булат Рамилевич ЭФМО-01-25
# Деплой контейнеризированного приложения в Kubernetes через минимальные манифесты


## 1. Kubernetes стенд и доступ kubectl

Использованный стенд: `minikube`.

Проверка:

```bash
kubectl get nodes
```

![get nodes](docs/screenshots/get%20nodes.png)

## 2. Как образ попал в кластер

Собран локальный образ:

```bash
docker build -t techip-tasks:0.1 -f services/tasks/Dockerfile .
```

![docker build](docs/screenshots/docker%20build.png)

Загружен в minikube без registry:

```bash
minikube image load techip-tasks:0.1
minikube image ls | grep techip-tasks
```

![image load](docs/screenshots/image%20load%20%2B%20ls.png)

Использован вариант: **локальная загрузка образа в minikube**.

## 3. Манифесты

Файлы:
- `deploy/k8s/configmap.yaml`
- `deploy/k8s/deployment.yaml`
- `deploy/k8s/service.yaml`

### 3.1 ConfigMap

`tasks-config` содержит параметры:
- `TASKS_PORT=8082`
- `DATABASE_URL=postgres://postgres:postgres@postgres:5432/tasks?sslmode=disable`
- `REDIS_ADDR=redis:6379`
- `CACHE_TTL_SECONDS=120`
- `CACHE_TTL_JITTER_SECONDS=30`
- `RABBIT_URL=amqp://guest:guest@rabbitmq:5672/`
- `QUEUE_NAME=task_jobs`
- `AUTH_GRPC_ADDR=auth:8083`
- `AUTH_BASE_URL=http://auth:8081`
- `LOG_LEVEL=info`

### 3.2 Deployment

`tasks` Deployment:
- `replicas: 1`
- `image: techip-tasks:0.1`
- `containerPort: 8082`
- `envFrom` из ConfigMap `tasks-config`
- `readinessProbe`: `GET /health`
- `livenessProbe`: `GET /health`

### 3.3 Service

`tasks` Service:
- тип: `ClusterIP`
- порт: `8082`
- `targetPort: http (8082)`

## 4. Применение манифестов и проверка

Применение:

```bash
kubectl apply -f deploy/k8s/configmap.yaml
kubectl apply -f deploy/k8s/deployment.yaml
kubectl apply -f deploy/k8s/service.yaml
```

![apply](docs/screenshots/apply.png)

Проверка:

```bash
kubectl get pods
kubectl get svc
kubectl describe pod tasks
```

![pods](docs/screenshots/pods.png)

![svc](docs/screenshots/svc.png)

![describe](docs/screenshots/describe.png)

для запуска `tasks` потребовался доступный PostgreSQL в кластере (поднят дополнительно `deploy/k8s/postgres.yaml`).

## 5. Демонстрация доступа

Port-forward:

```bash
kubectl port-forward svc/tasks 8082:8082
```

![port-forward](docs/screenshots/ports.png)

Проверка health:

```bash
curl -i http://127.0.0.1:8082/health
```

![health](docs/screenshots/health.png)
