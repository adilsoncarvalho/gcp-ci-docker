#!/bin/sh

. support.sh --source-only

info "==> Building image ${COLOR_IGREEN}ci/built-image${COLOR_OFF}"

log_and_run 'docker build . -t ci/built-image'
