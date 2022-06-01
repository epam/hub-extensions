#!./bats/bin/bats

setup_file() {
    cat > .env << EOF
BATS_DOTENV_TEST_A="TEST A"
BATS_DOTENV_TEST_B=""
EOF
    cat > .merge.env << EOF
BATS_DOTENV_TEST_C="TEST C"
EOF
}

setup() {
    load 'helpers/bats-support/load'
    load 'helpers/bats-assert/load'
    # ... the remaining setup is unchanged

    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"

    # make executables visible to PATH
    PATH="$DIR/../bin:$PATH"
}

@test "Test dotenv contains" {
    run dotenv contains "BATS_DOTENV_TEST_A"
    assert_success

    run dotenv contains "BATS_DOTENV_TEST_B"
    assert_success

    run dotenv contains "BATS_DOTENV_TEST_C"
    assert_failure
}

@test "Test dotenv get" {
    run dotenv get "BATS_DOTENV_TEST_A"
    assert_success
    assert_output "TEST A"

    run dotenv get "BATS_DOTENV_TEST_B"
    assert_success
    assert_output ""

    run dotenv get "BATS_DOTENV_TEST_C"
    assert_success
    assert_output ""
}

@test "Test dotenv keys" {
    run dotenv keys
    assert_success
    assert_line --index 0 "BATS_DOTENV_TEST_A"
    assert_line --index 1 "BATS_DOTENV_TEST_B"
}

@test "Test dotenv merge" {
    run dotenv merge -f .env -f .merge.env
    assert_success
    assert_line --index 0 'BATS_DOTENV_TEST_A="TEST A"'
    assert_line --index 1 'BATS_DOTENV_TEST_B=""'
    assert_line --index 2 'BATS_DOTENV_TEST_C="TEST C"'
}

@test "Test dotenv set" {
    run dotenv set 'BATS_DOTENV_TEST_C="TEST C"'
    assert_success

    run dotenv contains "BATS_DOTENV_TEST_C"
    assert_success

    run dotenv get "BATS_DOTENV_TEST_C"
    assert_success
    assert_output "TEST C"
}

@test "Test dotenv export" {
    run dotenv export
    assert_success
    assert_line --index 0 'export BATS_DOTENV_TEST_A="TEST A"'
    assert_line --index 1 'export BATS_DOTENV_TEST_B=""'
    assert_line --index 2 'export BATS_DOTENV_TEST_C="TEST C"'
}

teardown_file() {
    rm .env .merge.env
}
