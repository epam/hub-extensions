#!./bats/bin/bats

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

    MESSAGE="Hello world!"
}

do_not_print_newline() {
    color -n h "$MESSAGE" && echo "TEST"
}

@test "Test color -n" {
    run do_not_print_newline
    assert_success
    assert_output "${MESSAGE}TEST"
}

@test "Test color -e" {
    run color -e "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"
}

@test "Test color highlight" {
    run color h "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"

    run color highlight "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"
}

@test "Test color warning" {
    run color w "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"

    run color warn "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"

    run color warning "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"
}

@test "Test color error" {
    run color e "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"

    run color err "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"

    run color error "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"
}

@test "Test color bold" {
    run color b "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"

    run color bold "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"
}

@test "Test color green" {
    run color g "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"

    run color green "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"
}
