#!/bin/bash
AWS_PROFILE=cncf eksctl create nodegroup --cluster=CNCFcluster --nodes=3 --node-volume-type=gp2 --node-volume-size=32 --version=1.12 --name=CNCFnodegroup --node-type=m5.2xlarge --node-ami=auto --ssh-access
