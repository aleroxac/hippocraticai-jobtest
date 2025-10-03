``` shell
## app
cd src
python -m virtualenv .venv
source .venv/bin/activate
pip install -r src/requirements.txt
pip install -r src/requirements-dev.txt

docker build \
    --build-arg=API_HOST="0.0.0.0" \
    --build-arg=API_PORT="8000" \
    -f src/Dockerfile \
    -t gcr.io/aleroxac/hippocraticai-api:v1 src/

docker push gcr.io/aleroxac/hippocraticai-api:v1
cd -


## test
pytest -v



## terraform
gcloud auth login
gcloud auth application-default login

cd terraform
terraform init
terraform plan -out=bootstrap.plan
terraform apply bootstrap.plan

cd resources/dev
terraform init
terraform workspace new dev
terraform workspace select dev

terraform plan -out=plan.out
terraform apply plan.out
cd -



## kubernetes
cd k8s

## locally with k3d
k3d cluster create hippocraticai

## gke
gcloud components install gke-gcloud-auth-plugin
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
gcloud container clusters get-credentials demo-gke --region us-east1


## deploy
kubectl apply -f <(kubectl create ns hippocraticai --dry-run=client -o yaml)
kubens hippocraticai

kubectl apply -f k8s/config.yaml
helm install hippocraticai-api k8s/helmchart \
    --create-namespace=true \
    --namespace hippocraticai \
    -f k8s/values.yaml

kubectl wait --for=condition=ready pods -l app.kubernetes.io/name=hippocraticai-api

LB_IP=$(kubectl get svc/hippocraticai-api -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
curl -s ${LB_IP}:8000/health
curl -s ${LB_IP}:8000/hello


while true; do ab -n 5000 -c 500 http://172.18.0.2:8000/health; sleep 5; done
kubectl get hpa hippocraticai-api --watch
kubectl get events | grep -i ScalingReplicaSet
```
