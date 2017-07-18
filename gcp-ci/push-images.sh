#/bin/sh

. support.sh --source-only

info "==> Pushing images ($0)"

check_environment 'GCLOUD_PROJECT CIRCLE_PROJECT_REPONAME CIRCLE_SHA1'

if [ -z $(docker images | grep ci/built-image) ]; then
  error "ERROR: could not find image ${COLOR_IRED}ci/built${COLOR_RED}. Did you build it using ${COLOR_IRED}build-image.sh${COLOR_RED}?"
  exit 1
fi

debug " -> Current branch: ${COLOR_IPURPLE}$CIRCLE_BRANCH"

if [ "$CIRCLE_BRANCH" = 'master' ]; then
  # master will produce two images tagged as follows:
  # - SHA1
  # - latest

  log " -> Deploying us.gcr.io/$GCLOUD_PROJECT/$CIRCLE_PROJECT_REPONAME:$CIRCLE_SHA1"
  log_and_run "docker tag ci/built-image us.gcr.io/$GCLOUD_PROJECT/$CIRCLE_PROJECT_REPONAME:$CIRCLE_SHA1"
  log_and_run "gcloud docker -- push us.gcr.io/$GCLOUD_PROJECT/$CIRCLE_PROJECT_REPONAME:$CIRCLE_SHA1"

  log " -> Deploying us.gcr.io/$GCLOUD_PROJECT/$CIRCLE_PROJECT_REPONAME:latest"
  log_and_run "docker tag us.gcr.io/$GCLOUD_PROJECT/$CIRCLE_PROJECT_REPONAME:$CIRCLE_SHA1 us.gcr.io/$GCLOUD_PROJECT/$CIRCLE_PROJECT_REPONAME:latest"
  log_and_run "gcloud docker -- push us.gcr.io/$GCLOUD_PROJECT/$CIRCLE_PROJECT_REPONAME:latest"
else
  # any other branch will produce a single image as follows:
  # - feature/my-feature => feature-my-feature
  IMAGE_TAG_SUFFIX=$(echo $CIRCLE_BRANCH | sed -Ee 's/[^a-zA-Z0-9-]/-/g')

  log " -> Deploying us.gcr.io/$GCLOUD_PROJECT/$CIRCLE_PROJECT_REPONAME:$IMAGE_TAG_SUFFIX"
  log_and_run "docker tag ci/built-image us.gcr.io/$GCLOUD_PROJECT/$CIRCLE_PROJECT_REPONAME:$IMAGE_TAG_SUFFIX"
  log_and_run "gcloud docker -- push us.gcr.io/$GCLOUD_PROJECT/$CIRCLE_PROJECT_REPONAME:$IMAGE_TAG_SUFFIX"
fi
