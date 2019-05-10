#!/bin/bash
AWS_PROFILE=cncf-west-2 eksctl delete nodegroup --name=GQLnodegroup --cluster GQLcluster
AWS_PROFILE=cncf-west-2 eksctl delete cluster --name=GQLcluster
