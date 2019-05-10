#!/bin/bash
AWS_PROFILE=cncf eksctl delete nodegroup --name=CNCFnodegroup --cluster CNCFcluster
AWS_PROFILE=cncf eksctl delete cluster --name=CNCFcluster
