#!/bin/bash

set -euxo pipefail

TERRAFORM_MODULE_DIR="${PWD}"
OPA_REGO_DIR="${TERRAFORM_MODULE_DIR}/test/opa"
TERRAFORM_MODULE_WRAPPER_DIR="${TERRAFORM_MODULE_DIR}/test/fixtures/wrapper"
TERRAFORM_PLAN_BINARY="${TERRAFORM_MODULE_WRAPPER_DIR}/tfplan"
TERRAFORM_PLAN_JSON="${TERRAFORM_MODULE_WRAPPER_DIR}/tfplan.json"





if [[ ! -f "${TERRAFORM_PLAN_JSON}" ]]; then
  pushd "${TERRAFORM_MODULE_WRAPPER_DIR}"
  terraform plan -out "${TERRAFORM_PLAN_BINARY}"
  terraform show -json "${TERRAFORM_PLAN_BINARY}" > "${TERRAFORM_PLAN_JSON}"
  popd
fi

opa eval -i "${TERRAFORM_PLAN_JSON}" --data "${OPA_REGO_DIR}" "data.terraform.analysis.authz"
opa eval -i "${TERRAFORM_PLAN_JSON}" --data "${OPA_REGO_DIR}" "data.terraform.analysis.score"

