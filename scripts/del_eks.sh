#!/bin/bash
AWS_PROFILE=cncf eksctl delete nodegroup --name=GQLnodegroup --cluster GQLcluster
AWS_PROFILE=cncf eksctl delete cluster --name=GQLcluster
