OPA_TEST_DIR="${PWD}"

pushd ../fixtures/wrapper/
terraform plan -out "${OPA_TEST_DIR}/tfplan.binary"
terraform show -json "${OPA_TEST_DIR}/tfplan.binary" > "${OPA_TEST_DIR}/tfplan.json"
popd

opa eval -i "${OPA_TEST_DIR}/tfplan.json" --data "${OPA_TEST_DIR}"

