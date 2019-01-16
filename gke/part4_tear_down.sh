#!/bin/bash
#
# Part 4: Tear down resources

# Constants - CHANGE ME!
readonly PROJECT='gke-confluent-atlas'
readonly CLUSTER='storefront-api-non-prod'
readonly REGION='us-central1'

# Delete GKE cluster (time in foreground)
time yes | gcloud beta container clusters delete $CLUSTER --region $REGION

# Confirm network resources are also deleted
gcloud compute forwarding-rules list
gcloud compute target-pools list
gcloud compute firewall-rules list

# In case target-pool associated with Cluster is not deleted
yes | gcloud compute target-pools delete  \
  $(gcloud compute target-pools list \
      --filter="region:($REGION)" --project $PROJECT \
      | awk 'NR==2 {print $1}')
