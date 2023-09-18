#!./bats/bin/bats
# Copyright (c) 2023 EPAM Systems, Inc.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

gen_stack() {
    mkdir -p "$1"
    cat > "$1/.env" << EOF
HUB_DOMAIN_NAME="iamtest"
HUB_STACK_NAME="iamtest"
HUB_INTERACTIVE="0"
HUB_FILES="$1/hub.yaml"
HUB_ELABORATE="hub.elaborate"
EOF
    cat > "$1/hub.yaml" << EOF
version: 1
kind: stack
components:
- name: dummy1
  source:
    dir: component
- name: dummy2
  source:
    dir: component
parameters:
- name: hub.stackName
  fromEnv: HUB_STACK_NAME
EOF
}

gen_hubctl_double() {
    mkdir -p "$1"
    cat <<EOF > "$1/hubctl"
#!/bin/sh
echo ">> hubctl \$@"
EOF
    chmod +x "$1/hubctl"
    set +x
}

set_elaborate_hooks() {
    mkdir -p "$1/bin"
    cat <<EOF > "$1/bin/before"
#!/bin/sh -e
echo "hello from before elaborate"
EOF
    cat <<EOF > "$1/bin/after"
#!/bin/sh -e
echo "hello from after elaborate"
EOF
    chmod +x "$1/bin/before" "$1/bin/after"
    yq e -i '. += {"extensions":{"elaborate":{"before": ["bin/before"]}}}' "$1/hub.yaml"
    yq e -i '.extensions.elaborate += {"after": ["bin/after"]}' "$1/hub.yaml"
}

setup() {
    load 'helpers/bats-support/load'
    load 'helpers/bats-assert/load'
    # ... the remaining setup is unchanged

    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    CURRDIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    HUB_WORKDIR=$($CURRDIR/../bin/files abspath "$BATS_RUN_TMPDIR")
    PATH="$CURRDIR/..:$CURRDIR/../bin:$HUB_WORKDIR/bin:$PATH"
    export HUB_WORKDIR PATH

    HUB_OPTS="$HUB_WORKDIR/hub.elaborate -s $HUB_WORKDIR/hub.state"

    gen_stack "$HUB_WORKDIR"
    gen_hubctl_double "$HUB_WORKDIR/bin"
}

@test "hubctl stack elaborate should allow run from another directory" {
    refute test "$CURRDIR" = "$HUB_WORKDIR"
    # avoid trap in another directory if premature exit
    cd "$HUB_WORKDIR"
    run hub-stack-elaborate
    assert_success
    assert_line -p ">> hubctl elaborate $HUB_WORKDIR/hub.yaml -o $HUB_WORKDIR/hub.elaborate"

    # avoid trap in another directory if premature exit
    cd "$CURRDIR"
    run hub-stack-elaborate
    assert_success
    assert_line -p ">> hubctl elaborate $HUB_WORKDIR/hub.yaml -o $HUB_WORKDIR/hub.elaborate"
}

@test "hubctl stack elaborate should allow multiple elaborate file locations" {
    cd "$HUB_WORKDIR"
    run hub-stack-elaborate
    assert_line -p ">> hubctl elaborate $HUB_WORKDIR/hub.yaml -o $HUB_WORKDIR/hub.elaborate"

    # we should support URLs
    dotenv set HUB_ELABORATE "$HUB_WORKDIR/hub.elaborate,s3://fakebucket/hub.elaborate"
    run hub-stack-elaborate
    assert_line -p ">> hubctl elaborate $HUB_WORKDIR/hub.yaml -o $HUB_WORKDIR/hub.elaborate,s3://fakebucket/hub.elaborate"

    run hub-stack-elaborate
    dotenv set HUB_ELABORATE "hub.elaborate,s3://fakebucket/hub.elaborate"
}

@test "hubctl stack elaborate should allow to run pre and post elaborate hooks" {
    set_elaborate_hooks "$HUB_WORKDIR"
    run hub-stack-elaborate
    assert_line -p "hello from before elaborate"
    assert_line -p "hello from after elaborate"
}

teardown() {
    # if still trapped in another directory
    cd "$CURRDIR"
}
