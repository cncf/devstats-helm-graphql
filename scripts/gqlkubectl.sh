#!/bin/bash
KUBECONFIG=/root/.kube/config_gql AWS_PROFILE=cncf-west-2 kubectl "$@"
