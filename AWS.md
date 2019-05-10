# AWS Ingress setup

Remember to set `AWS_PROFILE` and `KUBECONFIG`.

- You should set namespace to 'devstats' first: `./switch_namespace.sh devstats`.
- First you need `ngingx-ingress`: `helm install stable/nginx-ingress --name nginx-ingress`.
- Note External-IP field from `kubectl --namespace devstats get services -o wide -w nginx-ingress-controller` when ready (zzz.us-east-1.elb.amazonaws.com).


# Setup Own domain

- Register a domain in AWS via: `aws route53domains register-domain --generate-cli-skeleton > domain/devstats.graphql.org.json`. Fill that JSON `vim domain/devstats.graphql.org.json`.
- Register domain via: `cat domain/devstats.graphql.org.json | jq -cM . | AWS_PROFILE=... xargs -d '\n' aws route53domains register-domain --cli-input-json`
- Use `aws route53 list-hosted-zones` to list hosted zones. Get the ZoneID (xxx).
- Use `aws route53 list-resource-record-sets --hosted-zone-id "/hostedzone/xxx"` to list hosted zone records.
- To add mapping to our `ingress-nginx`: `aws route53 change-resource-record-sets --hosted-zone-id xxx --change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"*.devstats.graphql.org.","Type":"CNAME","TTL":300,"ResourceRecords":[{"Value":"zzz.us-east-1.elb.amazonaws.com"}]}}]}'`.
- You will need a Zone ID (yyy) for the target ELB, find it via: `aws elb describe-load-balancers | grep Zone`.
- To add mapping for the domain itself (not subdomains): `aws route53 change-resource-record-sets --hosted-zone-id xxx --change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"devstats.graphql.org.","Type":"A","AliasTarget":{"HostedZoneId":"yyy","DNSName":"dualstack.zzz.us-east-1.elb.amazonaws.com.","EvaluateTargetHealth":false}}}]}'`


# Using existing domain

- Update `devstats.graphql.org` domain setup, make sure that `devstats.graphql.org` and wildcard `*.devstats.graphql.org` point to `zzz.us-east-1.elb.amazonaws.com` using CNAME record(s).


# SSL/HTTPS

- Now proceed to `cert-manager` installation in `SSL.md`.


Other useful command (not necesarily needed in this setup):

- Manually create AWS hosted zone: `aws route53 create-hosted-zone --name "devstats.graphql.org" --caller-reference "devstats.graphql.org-$(date +%s)"`. Note its ID.
- To list DNS servers assigned to this new hosted zone: `aws route53 list-resource-record-sets --output json --hosted-zone-id "/hostedzone/xxx" --query "ResourceRecordSets[?Type == 'NS']" | jq -r '.[0].ResourceRecords[].Value'`.
- To check if DNS is working: `dig +short @first-dns-server. graphiql.devstats.graphql.org`. you can use `anything.devstats.graphql.org` because this is a wildcard domain. Also `dig +short @second-dns-server. devstats.graphql.org` to check main domain.
- To actually test them: `links https://prometheus.devstats.graphql.org`.
- To delete wildcard record: `aws route53 change-resource-record-sets --hosted-zone-id xxx --change-batch '{"Changes": [{"Action": "DELETE","ResourceRecordSet": {"Name": "*","Type": "CNAME","TTL": 300,"ResourceRecords": [{ "Value": "zzz.us-east-1.elb.amazonaws.com"}]}}]}'`.
- To delete main record: `aws route53 change-resource-record-sets --hosted-zone-id xxx --change-batch '{"Changes":[{"Action":"DELETE","ResourceRecordSet":{"Name":"devstats.graphql.org.","Type":"A","AliasTarget":{"HostedZoneId":"yyy","DNSName":"dualstack.zzz.us-east-1.elb.amazonaws.com.","EvaluateTargetHealth":false}}}]}'`
- To delete hosted zone: `AWS_PROFILE=cncf-west-2 aws route53 delete-hosted-zone --id "/hostedzone/xxx"`.
