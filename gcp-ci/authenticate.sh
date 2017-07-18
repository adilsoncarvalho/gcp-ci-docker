#!/bin/sh

. support.sh --source-only

info "==> Authentication ($0)"

check_environment 'GCLOUD_API_KEYFILE GCLOUD_PROJECT GCLOUD_CLUSTER GCLOUD_ZONE'

log_and_run 'echo $GCLOUD_API_KEYFILE | base64 -d > ~/source/gcloud-api-key.json'
log_and_run 'gcloud auth activate-service-account --key-file ~/source/gcloud-api-key.json'
log_and_run 'gcloud config set project $GCLOUD_PROJECT'
log_and_run 'gcloud container clusters get-credentials $GCLOUD_CLUSTER --zone=$GCLOUD_ZONE'
