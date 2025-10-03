# hippocratic-ai-jobtest


## Objective
​​Deploy a simple web application using GKE with autoscaling based on CPU utilization, all​
​orchestrated via Terraform.​

## Requirements:
​Use a simple containerized web application (e.g., a Python Flask app serving “Hello,​
​World!”).​
-​ ​Provision:
    - ​GKE cluster (standard, not Autopilot).​
    - ​Kubernetes Deployment for the app [preferably use Helm for deployment]​
    - ​Kubernetes Service with a LoadBalancer type or use Ingress.​
- ​Configure Horizontal Pod Autoscaler (HPA):
    ​- ​Target CPU utilization threshold for autoscaling.​
    ​- ​Scale out when CPU > 50%, scale in when < 20%.​
    ​- ​Min: 1 pod, Max: 3 pods.​
- ​Set up Terraform configurations (can use community GKE modules or write your own).​
- ​Simulate CPU load (e.g., using stress or hey) and demonstrate autoscaling behavior.​
- ​Optional: Add logging/monitoring integration and a CI/CD pipeline.​
- ​Provide an architecture diagram that illustrates the components and their interactions​
​within the solution.​
