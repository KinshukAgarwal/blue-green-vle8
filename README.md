# VLE-8 – Blue-Green Deployment (Terraform · Ansible · Docker · Kubernetes · Jenkins)

Kinshuk Agarwal (RA2311033010079). Everything ran on one AWS EC2 (t3.small, Ubuntu 26.04, us-east-1).

| Step | Files | What happens |
|---|---|---|
| 1 Terraform | `terraform/main.tf`, `terraform/localstack_override.tf` | `aws_instance.jenkins` (t2.medium, ap-south-1), applied against LocalStack on the EC2 (no AWS API credentials in this lab) |
| 2 Ansible | `ansible/jenkins_setup.yml`, `ansible/inventory.ini` | Installs docker.io, k3s (Docker runtime) and runs Jenkins in Docker, over SSH to the EC2 itself |
| 3 App | `index.html`, `Dockerfile`, `.dockerignore` | `myapp:v1` = tag `v1` (BLUE page), `myapp:v2` = tag `v2`/`main` (GREEN page) |
| 4–6 K8s | `deployment-blue.yaml`, `deployment-green.yaml`, `service.yaml` | Blue live, green in parallel, Service selector chooses the colour |
| 7 Jenkins | `Jenkinsfile`, `jenkins/` | Build → Deploy Green → input "Switch to Green?" → patch Service |
| 8–9 | `scripts/traffic-check.sh` | Continuous curl during switch / rollback: 0 failed requests |

```bash
kubectl patch service myapp-service -p '{"spec":{"selector":{"app":"myapp","color":"green"}}}'  # switch
kubectl patch service myapp-service -p '{"spec":{"selector":{"app":"myapp","color":"blue"}}}'   # rollback
```

Deviations: k3s instead of Minikube (2 GB RAM), LocalStack instead of real AWS for Terraform,
Jenkins bound to 127.0.0.1 with an admin password generated on the server (not in Git).
