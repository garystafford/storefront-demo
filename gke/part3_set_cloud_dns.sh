#!/bin/bash
#
# Part 3: Update Cloud DNS A Records for new GKE cluster

# Constants - CHANGE ME!
readonly PROJECT='gke-confluent-atlas'
readonly DOMAIN='storefront-demo.com'
readonly ZONE='storefront-demo-com-zone'
readonly REGION='us-central1'
readonly TTL=300
readonly RECORDS=('dev' 'test' 'uat')

if [ $(gcloud compute forwarding-rules list --filter "region:($REGION)" | wc -l | awk '{$1=$1};1') -gt 2 ]; then
  echo "More than one load balancer detected. Exiting script."
  exit 1
fi

gcloud compute forwarding-rules list \
  --filter "region:($REGION)"  | wc -l

# Get load balancer IP address from first record
readonly OLD_IP=$(gcloud dns record-sets list \
    --filter "name=${RECORDS[0]}.api.${DOMAIN}." --zone $ZONE \
  | awk 'NR==2 {print $4}')

readonly NEW_IP=$(gcloud compute forwarding-rules list \
    --filter "region:($REGION)" \
  | awk 'NR==2 {print $3}')

echo "Old LB IP Address: ${OLD_IP}"
echo "New LB IP Address: ${NEW_IP}"

# Update DNS records
gcloud dns record-sets transaction start --zone $ZONE

for record in ${RECORDS[@]}; do
  echo "${record}.api.${DOMAIN}."

  gcloud dns record-sets transaction remove \
    --name "${record}.api.${DOMAIN}." --ttl $TTL \
    --type A --zone $ZONE "${OLD_IP}"

  gcloud dns record-sets transaction add \
    --name "${record}.api.${DOMAIN}." --ttl $TTL \
    --type A --zone $ZONE "${NEW_IP}"
done

gcloud dns record-sets transaction execute --zone $ZONE
