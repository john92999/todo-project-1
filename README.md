# Todo App - Kubernetes Setup

## Directory Structure
```
k8s/
├── namespace.yaml
├── mongo/
│   ├── mongo-secret.yaml
│   ├── mongo-pvc.yaml
│   └── mongo-statefulset.yaml
├── api/
│   └── api-deployment.yaml
├── ui/
│   ├── ui-configmap.yaml
│   └── ui-deployment.yaml
└── ingress/
    └── ingress.yaml
```

## Before You Apply

### 1. Replace Docker Hub username in:
- `api/api-deployment.yaml` → `YOUR_DOCKERHUB_USERNAME/todo-api:v1`
- `ui/ui-deployment.yaml`  → `YOUR_DOCKERHUB_USERNAME/todo-ui:v1`

### 2. Replace domain in:
- `ui/ui-configmap.yaml`  → `REACT_APP_BACKEND_SERVER_URL`
- `ingress/ingress.yaml`  → `host: todo.example.com`

Use your ingress IP if you don't have a domain:
```bash
# Get ingress IP after installing ingress controller
kubectl get svc -n ingress-nginx
# Use that EXTERNAL-IP in both files above
```

---

## Apply Order (IMPORTANT — order matters)

```bash
# 1. Namespace first
kubectl apply -f namespace.yaml

# 2. MongoDB — secret, volume, then statefulset
kubectl apply -f mongo/mongo-secret.yaml
kubectl apply -f mongo/mongo-pvc.yaml
kubectl apply -f mongo/mongo-statefulset.yaml

# Wait for MongoDB to be ready
kubectl rollout status statefulset/todo-mongo -n todo-app

# 3. API
kubectl apply -f api/api-deployment.yaml

# Wait for API to be ready
kubectl rollout status deployment/todo-api -n todo-app

# 4. UI
kubectl apply -f ui/ui-configmap.yaml
kubectl apply -f ui/ui-deployment.yaml

# 5. Ingress (install controller first if needed — see below)
kubectl apply -f ingress/ingress.yaml
```

---

## Install Nginx Ingress Controller (if not already installed)

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.0/deploy/static/provider/cloud/deploy.yaml

# Wait for it to be ready
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```

---

## Verify Everything

```bash
# Check all pods are Running
kubectl get pods -n todo-app

# Check services
kubectl get svc -n todo-app

# Check HPA
kubectl get hpa -n todo-app

# Check ingress
kubectl get ingress -n todo-app

# Check PVC is Bound
kubectl get pvc -n todo-app

# Stream API logs
kubectl logs -f deployment/todo-api -n todo-app

# Stream UI logs
kubectl logs -f deployment/todo-ui -n todo-app
```

---

## How Everything Connects

```
Browser
  └── Ingress (todo.example.com)
        ├── /       → todo-ui-service:80     → todo-ui pods
        └── /api    → todo-api-service:8080  → todo-api pods
                                                    └── todo-mongo-service:27017
                                                          └── MongoDB StatefulSet
                                                                └── PVC → /data/db
```

## Key Design Decisions

| Component | Why |
|-----------|-----|
| MongoDB as StatefulSet | Stable network identity + persistent storage |
| PVC with Retain policy | Data survives pod restarts and deletions |
| Secrets for credentials | Never hardcode passwords in yamls |
| ConfigMap for UI URL | Change backend URL without rebuilding image |
| initContainer for env.js | Injects window._env_ at runtime — works with any IP/domain |
| HPA on API + UI | Auto-scales based on CPU/memory load |
| Ingress | Single entry point, routes / to UI and /api to backend |
