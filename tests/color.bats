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

@test "color -n: should not print the trailing newline character" {
    run do_not_print_newline
    assert_success
    assert_output "${MESSAGE}TEST"
}

@test "color -e: should print to stderr" {
    run color -e "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"
}

@test "color highlight: should print message" {
    run color h "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"

    run color highlight "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"
}

@test "color warning: should print message" {
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

@test "color error: should print message" {
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

@test "color bold: should print message" {
    run color b "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"

    run color bold "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"
}

@test "color green: should print message" {
    run color g "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"

    run color green "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"
}

@test "color --color: should print message in color" {
    run color --color 0 "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"
    run color -c 0 "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"
    run color +c 0 "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"
}

@test "color --bold: should print message in bold" {
    run color +b "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"
    run color --bold "$MESSAGE"
    assert_success
    assert_output "$MESSAGE"
}
