# Money System Helm Charts

Helm charts cho hệ thống Money Management với tích hợp AI Chatbot.

## Cấu trúc

```
helm/
├── charts/
│   ├── aichat-bot/       # Chart cho AI Chatbot
│   └── calculate-money/  # Chart cho Money Management System
└── umbrella/            # Umbrella chart để deploy toàn bộ hệ thống
```

## Yêu cầu

- Kubernetes 1.19+
- Helm 3.0+
- Ingress Controller (nginx)
- cert-manager (cho SSL trong production)

## Cài đặt

1. **Thêm Bitnami repository:**
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

2. **Cài đặt theo môi trường:**

Development:
```bash
helm install money-system ./umbrella \
  --values ./umbrella/values-dev.yaml \
  --namespace money-system-dev \
  --create-namespace
```

Staging:
```bash
helm install money-system ./umbrella \
  --values ./umbrella/values-staging.yaml \
  --namespace money-system-staging \
  --create-namespace
```

Production:
```bash
# Tạo secrets cho production
kubectl create secret generic prod-secrets \
  --from-literal=MONGODB_ROOT_PASSWORD='your-root-password' \
  --from-literal=MONGODB_PASSWORD='your-password' \
  --from-literal=REDIS_PASSWORD='your-redis-password' \
  --from-literal=JWT_SECRET_KEY='your-jwt-secret' \
  --namespace money-system-prod

# Install chart
helm install money-system ./umbrella \
  --values ./umbrella/values-prod.yaml \
  --namespace money-system-prod \
  --create-namespace
```

## Cấu hình

Mỗi môi trường có file values riêng:
- `values-dev.yaml`: Môi trường phát triển
- `values-staging.yaml`: Môi trường staging
- `values-prod.yaml`: Môi trường production

### Cấu hình chính:

1. **Global:**
```yaml
global:
  environment: production
  domain: example.com
  mongodb:
    enabled: true
  redis:
    enabled: true
```

2. **AI Chatbot:**
```yaml
aichat-bot:
  enabled: true
  config:
    calculateMoney:
      apiUrl: http://money-system-calculate-money/api/v1
```

3. **Money Management System:**
```yaml
calculate-money:
  enabled: true
  frontend:
    enabled: true
```

## Quản lý

### Kiểm tra trạng thái:
```bash
helm ls -n money-system-dev
helm status money-system -n money-system-dev
```

### Cập nhật:
```bash
helm upgrade money-system ./umbrella \
  --values ./umbrella/values-dev.yaml \
  --namespace money-system-dev
```

### Gỡ cài đặt:
```bash
helm uninstall money-system -n money-system-dev
```

## Monitoring & Logging

Trong môi trường production:
- Prometheus metrics được bật mặc định
- ServiceMonitor được tạo cho Prometheus Operator

## Backup

Trong production:
- MongoDB backup chạy hàng ngày lúc 1:00 AM
- Backup được lưu vào S3

## Security

- TLS được cấu hình thông qua cert-manager trong production
- Secrets được quản lý riêng cho mỗi môi trường
- RBAC được áp dụng cho service accounts

## Development

### Thêm service mới:
1. Tạo chart mới trong thư mục `charts/`
2. Thêm dependency trong `umbrella/Chart.yaml`
3. Thêm cấu hình trong các file values

### Testing:
```bash
# Kiểm tra template
helm template money-system ./umbrella \
  --values ./umbrella/values-dev.yaml

# Kiểm tra cài đặt
helm install money-system ./umbrella \
  --values ./umbrella/values-dev.yaml \
  --dry-run --debug
