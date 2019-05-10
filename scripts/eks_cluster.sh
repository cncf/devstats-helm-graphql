#!/bin/bash
AWS_PROFILE=cncf-west-2 eksctl create cluster --name=GQLcluster --nodes=3 --kubeconfig=/root/.kube/config_gql --tags node=gql --node-volume-type=gp2 --node-volume-size=32 --version=1.12 --nodegroup-name=GQLnodegroup --node-type=m5.2xlarge --node-ami=auto --ssh-access
