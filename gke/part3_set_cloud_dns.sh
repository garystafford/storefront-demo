#!/bin/bash
#
# Update Cloud DNS A Records for new GKE cluster

# Constants - CHANGE ME!
readonly PROJECT='gke-confluent-atlas'
readonly DOMAIN='storefront-demo.com'
readonly ZONE='storefront-demo-com-zone'
readonly REGION='us-east1'
readonly TTL=300
readonly RECORDS=(api.dev api.test api.staging api)

# Get load balancer IP address
readonly OLD_IP=$(gcloud dns record-sets list \
  --filter "name=${RECORDS[0]}.${DOMAIN}." --zone $ZONE \
  | awk 'NR==2 {print $4}')

readonly NEW_IP=$(gcloud compute forwarding-rules list \
  --filter="region:($REGION)" \
  | awk 'NR==2 {print $3}')

echo "Old IP Address: $OLD_IP"
echo "New IP Address: $NEW_IP"

# Update DNS records
gcloud dns record-sets transaction start --zone=$ZONE

for record in ${RECORDS[@]}
do
  echo "${record}.${DOMAIN}."

  gcloud dns record-sets transaction remove \
    --name="${record}.${DOMAIN}." --ttl=$TTL \
    --type=A --zone=$ZONE "${OLD_IP}"

  gcloud dns record-sets transaction add \
    --name="${record}.${DOMAIN}." --ttl=$TTL \
    --type=A --zone=$ZONE "${NEW_IP}"
done

gcloud dns record-sets transaction execute --zone=$ZONE
