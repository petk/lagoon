#!/bin/sh


# Check if the container runs in Kubernetes/OpenShift
if [ -z "$POD_NAMESPACE" ]; then
  # Single container runs in docker
  echo "POD_NAMESPACE not set, spin up single node"
  exec docker-entrypoint.sh rabbitmq-server
fi

# clustering uses full hostnames, generate those
echo NODENAME=rabbit@${HOSTNAME}.${SERVICE_NAME}.${POD_NAMESPACE}.svc.cluster.local > /etc/rabbitmq/rabbitmq-env.conf
echo cluster_formation.k8s.hostname_suffix=.${SERVICE_NAME}.${POD_NAMESPACE}.svc.cluster.local >> /etc/rabbitmq/rabbitmq.conf
echo cluster_formation.k8s.service_name=${SERVICE_NAME}-headless >> /etc/rabbitmq/rabbitmq.conf

# start the server
docker-entrypoint.sh rabbitmq-server
