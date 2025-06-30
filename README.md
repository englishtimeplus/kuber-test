docker save my-nextjs-app:latest -o my-nextjs-app.tar

microk8s ctr image import my-nextjs-app.tar

microk8s kubectl apply -f deployment.yaml
