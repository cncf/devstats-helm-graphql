#!/bin/bash
KUBECONFIG=/root/.kube/config_cncf AWS_PROFILE=cncf kubectl "$@"
