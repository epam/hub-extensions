#!./bats/bin/bats

setup_file() {
  # Create .env file
  export DOTENV_FILE=".bats.env"
  cat >"$DOTENV_FILE" <<EOF
BATS_ENVVARS_TEST1="envvar_test1"
BATS_ENVVARS_TEST2="envvar_test2"
BATS_ENVVARS_TEST3="envvar_test3"
EOF

  # Create hubfile
  export HUB_FILE="bats.params.yaml"
  cat >"$HUB_FILE" <<EOF
parameters:
- name: bats.parameter1
  value: test1
- name: bats.parameter2
  value: test2
  default: default_test2
- name: bats.parameter3
  value: true
- name: bats.parameter4
  value: 12345
- name: bats.parameter5
  value: "String with spaces"
- name: bats.parameter6
  value: |
    Here is
    Multiline text
- name: bats.parameter7
  value: [value1, value2]
- name: bats.parameter8
  value:
    myfield1: myValue1
    myfield2: myValue3
- name: bats.parameter9
  value:
    name: myName
    value: myValue
    myfield1: myValue1
- name: bats.parameter10
  value: parameter10
  default: default_parameter10
- name: bats.parameter11
  default: default_parameter11

- name: bats.parameters
  parameters:
  - name: test1
    value: TEST1
  - name: test2
    value: test2
  - name: test3
    value: test3

- name: bats.envvars
  parameters:
  - name: test1
    fromEnv: BATS_ENVVARS_TEST1
  - name: test2
    fromEnv: BATS_ENVVARS_TEST2
    value: test2
  - name: test3
    fromEnv: BATS_ENVVARS_TEST3
    default: default_test3
  - name: test4
    fromEnv: BATS_ENVVARS_TEST4
    default: default_test4
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

@test "params flatten: should print all parameters in json plain format" {
  run params flatten -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '[{"name":"bats.parameter1","value":"test1"},{"name":"bats.parameter2","value":"test2","default":"default_test2"},{"name":"bats.parameter3","value":true},{"name":"bats.parameter4","value":12345},{"name":"bats.parameter5","value":"String with spaces"},{"name":"bats.parameter6","value":"Here is\nMultiline text\n"},{"name":"bats.parameter7","value":["value1","value2"]},{"name":"bats.parameter8","value":{"myfield1":"myValue1","myfield2":"myValue3"}},{"name":"bats.parameter9","value":{"myName":{"value":"myValue","myfield1":"myValue1"}}},{"name":"bats.parameter10","value":"parameter10","default":"default_parameter10"},{"name":"bats.parameter11","default":"default_parameter11"},{"name":"bats.parameters.test1","value":"TEST1"},{"name":"bats.parameters.test2","value":"test2"},{"name":"bats.parameters.test3","value":"test3"},{"name":"bats.envvars.test1","fromEnv":"BATS_ENVVARS_TEST1"},{"name":"bats.envvars.test2","fromEnv":"BATS_ENVVARS_TEST2","value":"test2"},{"name":"bats.envvars.test3","fromEnv":"BATS_ENVVARS_TEST3","default":"default_test3"},{"name":"bats.envvars.test4","fromEnv":"BATS_ENVVARS_TEST4","default":"default_test4"}]'
}

@test "params listenv: should print list of envvars declared in fromEnv field of parameters" {
  run params listenv -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_line --index 0 "BATS_ENVVARS_TEST1"
  assert_line --index 1 "BATS_ENVVARS_TEST2"
  assert_line --index 2 "BATS_ENVVARS_TEST3"
}

@test "params json: should print parameter in json plain format by give name" {
  COMMAND="json"

  run params $COMMAND "bats.parameter1" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '{"value":"test1","name":"bats.parameter1"}'

  run params $COMMAND "bats.parameter2" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '{"value":"test2","default":"default_test2","name":"bats.parameter2"}'

  run params $COMMAND "bats.parameter3" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '{"value":true,"name":"bats.parameter3"}'

  run params $COMMAND "bats.parameter4" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '{"value":12345,"name":"bats.parameter4"}'

  run params $COMMAND "bats.parameter5" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '{"value":"String with spaces","name":"bats.parameter5"}'

  run params $COMMAND "bats.parameter6" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '{"value":"Here is\nMultiline text\n","name":"bats.parameter6"}'

  run params $COMMAND "bats.parameter7" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '{"value":["value1","value2"],"name":"bats.parameter7"}'

  run params $COMMAND "bats.parameter8" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '{"value":{"myfield1":"myValue1","myfield2":"myValue3"},"name":"bats.parameter8"}'

  run params $COMMAND "bats.parameter9" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '{"value":{"myName":{"value":"myValue","myfield1":"myValue1"}},"name":"bats.parameter9"}'
}

@test "params envvar: should print parameter in json plain format by give envvar" {
  COMMAND="envvar"

  run params $COMMAND "BATS_ENVVARS_TEST1" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '{"name":"bats.envvars.test1","fromEnv":"BATS_ENVVARS_TEST1"}'

  run params $COMMAND "BATS_ENVVARS_TEST2" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '{"name":"bats.envvars.test2","fromEnv":"BATS_ENVVARS_TEST2","value":"test2"}'

  run params $COMMAND "BATS_ENVVARS_TEST3" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '{"name":"bats.envvars.test3","fromEnv":"BATS_ENVVARS_TEST3","default":"default_test3"}'
}

@test "params value: should print parameter value" {
  COMMAND="value"

  run params $COMMAND "bats.parameter1" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output "test1"

  run params $COMMAND "bats.parameter2" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output "test2"

  run params $COMMAND "bats.parameter3" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output "true"

  run params $COMMAND "bats.parameter4" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output "12345"

  run params $COMMAND "bats.parameter5" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output "String with spaces"

  run params $COMMAND "bats.parameter6" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_line --index 0 "Here is"
  assert_line --index 1 "Multiline text"

  run params $COMMAND "bats.parameter7" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '["value1","value2"]'

  run params $COMMAND "bats.parameter8" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '{"myfield1":"myValue1","myfield2":"myValue3"}'

  run params $COMMAND "bats.parameter9" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output '{"myName":{"value":"myValue","myfield1":"myValue1"}}'

  run params $COMMAND "bats.parameter10" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output 'parameter10'

  run params $COMMAND "bats.parameter11" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output 'default_parameter11'

  run params $COMMAND "bats.envvars.test1" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output 'envvar_test1'

  run params $COMMAND "bats.envvars.test2" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output 'test2'

  run params $COMMAND "bats.envvars.test3" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output 'envvar_test3'

  run params $COMMAND "bats.envvars.test4" -f "$HUB_FILE" -d "$DOTENV_FILE"
  assert_success
  assert_output 'default_test4'
}

teardown_file() {
    rm "$DOTENV_FILE" "$HUB_FILE"
}
