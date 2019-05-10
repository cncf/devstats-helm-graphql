#!/bin/bash
# DRYRUN=1 (only display what would be done)

i=0
while true
do
  i=$((i+1))
  if [ "$i" = "1" ]
  then
    # CNCF cleanup
    export AWS_PROFILE='cncf'
    export KUBECONFIG='/root/.kube/config_cncf'
  fi
  if [ "$i" = "2" ]
  then
    # LF cleanup
    export AWS_PROFILE='lfproduct-dev'
    export KUBECONFIG='/root/.kube/config_lf'
  fi
  if [ "$i" = "3" ]
  then
    # GQL cleanup
    export AWS_PROFILE='cncf-west-2'
    export KUBECONFIG='/root/.kube/config_gql'
  fi
  pods=""
  for data in `kubectl get po -l name=devstats -o=jsonpath='{range .items[*]}{.metadata.name}{";"}{.status.phase}{"\n"}{end}'`
  do
    IFS=';'
    arr=($data)
    unset IFS
    pod=${arr[0]}
    sts=${arr[1]}
    base=${pod:0:8}
    #echo "$data -> $pod $sts $base"
    if ( [ "$sts" = "Succeeded" ] && [ "$base" = "devstats" ] )
    then
      pods="${pods} ${pod}"
    fi
  done
  if [ ! -z "$pods" ]
  then
    if [ -z "$DRYRUN" ]
    then
      echo "Deleting pods: ${pods}"
      kubectl delete pod ${pods}
    else
      echo "Would delete pods: ${pods}"
    fi
  fi
  if [ "$i" = "3" ]
  then
    break
  fi
done
