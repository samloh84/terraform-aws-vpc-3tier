#!/bin/bash

set -euxo pipefail

TERRAFORM_MODULE_DIR="${PWD}"
TERRAFORM_MODULE_WRAPPER_DIR="${TERRAFORM_MODULE_DIR}/test/fixtures/wrapper"
TERRAFORM_PLAN_BINARY="${TERRAFORM_MODULE_WRAPPER_DIR}/tfplan"
TERRAFORM_PLAN_JSON="${TERRAFORM_MODULE_WRAPPER_DIR}/tfplan.json"


if [[ ! -f "${TERRAFORM_PLAN_JSON}" ]]; then
  pushd "${TERRAFORM_MODULE_WRAPPER_DIR}"
  terraform plan -out "${TERRAFORM_PLAN_BINARY}"
  terraform show -json "${TERRAFORM_PLAN_BINARY}" > "${TERRAFORM_PLAN_JSON}"
  popd
fi

checkov -f "${TERRAFORM_PLAN_JSON}"
