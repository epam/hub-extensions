#!./bats/bin/bats

setup_file() {
  # Create .env file
  export DOTENV_FILE=".env"
  cat >"$DOTENV_FILE" <<EOF
HUB_INTERACTIVE1="ask_test1"
HUB_FILES="ask.params-component.yaml"
EOF

  # Create hubfile
  export HUB_FILES="ask.params-component.yaml"
  cat >"$HUB_FILES" <<EOF
parameters:
  - name: ingress.hosts
    component: test1
    fromEnv: KUBEFLOW_HOST
  - name: ingress.hosts
    component: test2
    fromEnv: ARGO_HOST
  - name: test.hosts
    component: test3
    fromEnv: BATS_TEST_HOST
EOF
}

setup() {
  load 'helpers/bats-support/load'
  load 'helpers/bats-assert/load'

  # get the containing directory of this file
  # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
  # as those will point to the bats executable's location or the preprocessed file respectively
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"

  # make executables visible to PATH
  PATH="$DIR/../bin:$PATH"
}

@test "ask contains -e: should error code without correct parameter" {
  run ask contains "HUB_INTERACTIVE1"
  assert_failure
}

# This test simulates user input for ARGO_HOST and KUBEFLOW_HOST parameters
@test "ask env: should print messages if parameters need to set for different component discriminators" {
  run ask env "ARGO_HOST" -m "parameter ingress.hosts test1" +empty -d "$DOTENV_FILE" -ask-env --non-interactive
  assert_success
  assert_output --partial "* Setting parameter ingress.hosts test1, ARGO"
  assert_output --partial "  ARGO_HOST saved"

  run ask env "KUBEFLOW_HOST" -m "parameter ingress.hosts test2" +empty -d "$DOTENV_FILE" -ask-env --non-interactive
  assert_success
  assert_output --partial "* Setting parameter ingress.hosts test2, KUBEFLOW"
  assert_output --partial "  KUBEFLOW_HOST saved"
}

@test "ask env: should success if env exist" {
  run ask env "HUB_INTERACTIVE1" -m "executor" -a "hub.executor" --suggest "local" --brief "$BRIEF"
  assert_success
}

@test "ask env: should print messages if parameters already set for different component discriminators" {
  run ask env "ARGO_HOST" -m "parameter ingress.hosts test1" +empty -d "$DOTENV_FILE" -ask-env
  assert_success
  assert_output --partial "* Setting parameter ingress.hosts test1, ARGO_HOST"
  assert_output --partial "ARGO_HOST already set"

  run ask env "KUBEFLOW_HOST" -m "parameter ingress.hosts test2" +empty -d "$DOTENV_FILE" -ask-env
  assert_success
  assert_output --partial "* Setting parameter ingress.hosts test2, KUBEFLOW_HOST"
  assert_output --partial "KUBEFLOW_HOST already set"
}

# This test simulates the user entering the BATS_TEST_HOST parameter
@test "ask env: should print messages if parameter need to set without different component discriminators" {
  run ask env "BATS_TEST_HOST" -m "parameter test.hosts test3" +empty -d "$DOTENV_FILE" -ask-env --non-interactive
  assert_success
  assert_output --partial "* Setting parameter test.hosts test3, BATS_TEST_HOST"
  assert_output --partial "BATS_TEST_HOST saved"
}

@test "ask env: should print messages if parameter already set without different component discriminators" {
  run ask env "BATS_TEST_HOST" -m "parameter test.hosts test3" +empty -d "$DOTENV_FILE" -ask-env
  assert_success
  assert_output --partial "* Setting parameter test.hosts test3, BATS_TEST_HOST"
  assert_output --partial "BATS_TEST_HOST already set"
}

teardown_file() {
  rm "$HUB_FILES" "$DOTENV_FILE"
  rm -rf ".hub"
}
