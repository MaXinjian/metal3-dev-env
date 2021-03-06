#!/bin/bash

set -x

METAL3_DEV_ENV_DIR="$(dirname "$(readlink -f "${0}")")/../../../"

# Remove old test result
rm -rf /tmp/"$(date +%Y.%m.%d_upgrade.result.txt)"

# shellcheck disable=SC1091
# shellcheck disable=SC1090
source "${METAL3_DEV_ENV_DIR}/lib/common.sh"

# shellcheck disable=SC1091
# shellcheck disable=SC1090
source "${METAL3_DEV_ENV_DIR}/lib/releases.sh"

# shellcheck disable=SC1091
# shellcheck disable=SC1090
source "${METAL3_DEV_ENV_DIR}/lib/network.sh"

# shellcheck disable=SC1091
# shellcheck disable=SC1090
source "${METAL3_DEV_ENV_DIR}/lib/images.sh"

# -----------------------------------------
# Syntax:
# source <script name>.sh <log file prefix>
# -----------------------------------------

# Run cluster level ugprade tests
pushd "${METAL3_DEV_ENV_DIR}/scripts/feature_tests/upgrade" || exit
# shellcheck disable=SC1091
source 1cp_1w_bootDiskImage_cluster_upgrade.sh
popd || exit

pushd "${METAL3_DEV_ENV_DIR}/scripts/feature_tests/upgrade" || exit
# shellcheck disable=SC1091
source clean_setup_env.sh
popd || exit

# Run worker upgrade cases
pushd "${METAL3_DEV_ENV_DIR}/scripts/feature_tests/upgrade/workers_upgrade" || exit
# shellcheck disable=SC1091
source 1cp_3w_bootDiskImage_scaleInWorkers_upgrade_both.sh
popd || exit

pushd "${METAL3_DEV_ENV_DIR}/scripts/feature_tests/upgrade" || exit
# shellcheck disable=SC1091
source clean_setup_env.sh
popd || exit

# Run controlplane upgrade tests
pushd "${METAL3_DEV_ENV_DIR}/scripts/feature_tests/upgrade/controlplane_upgrade" || exit
# shellcheck disable=SC1091
source 3cp_1w_k8sVer_bootDiskImage_scaleInWorker_upgrade.sh
popd || exit

# TODO: 1cp_1w_bootDiskImageANDK8sControllers_clusterLevel_upgrade requires
# ironic running as a pod and thus minikube.
# https://github.com/metal3-io/metal3-dev-env/issues/427 bug fix needed before
# this case works in CI 
# Run controlplane components upgrade tests | This should be the last one
### pushd "${METAL3_DEV_ENV_DIR}/scripts/feature_tests/upgrade/combined_tests" || exit
# shellcheck disable=SC1091
### source 1cp_1w_bootDiskImageANDK8sControllers_clusterLevel_upgrade.sh
### popd || exit

set +x
