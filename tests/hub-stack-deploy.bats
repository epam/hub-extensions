#!./bats/bin/bats
# Copyright (c) 2023 EPAM Systems, Inc.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

setup_file() {
    cat > "$BATS_RUN_TMPDIR/.env" << EOF
HUB_DOMAIN_NAME="iamtest"
HUB_STACK_NAME="iamtest"
HUB_WORKDIR="$BATS_RUN_TMPDIR"
HUB_INTERACTIVE="0"
HUB_FILES="hub.yaml"
HUB_STATE="$BATS_RUN_TMPDIR/hub.state"
HUB_ELABORATE="$BATS_RUN_TMPDIR/hub.elaborate"
EOF

    mkdir -p "$BATS_RUN_TMPDIR/component"
    cat > "$BATS_RUN_TMPDIR/hub.yaml" << EOF
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

    cat <<EOF > "$BATS_RUN_TMPDIR/hubctl"
#!/bin/sh
echo "\$ hubctl \$@"
EOF
    cat <<EOF > "$BATS_RUN_TMPDIR/component/hub-component.yaml"
---
version: 1
kind: component
parameters:
- name: hub.stackName
  env: WORLD
EOF
    cat <<EOF > "$BATS_RUN_TMPDIR/component/deploy"
#!/bin/sh -e
echo "hello, \$WORLD \$VERB!"
EOF
    cat <<EOF > "$BATS_RUN_TMPDIR/component/undeploy"
#!/bin/sh -e
echo "hello, \$WORLD \$VERB!"
EOF
    chmod +x \
        "$BATS_RUN_TMPDIR/component/deploy" \
        "$BATS_RUN_TMPDIR/component/undeploy" \
        "$BATS_RUN_TMPDIR/hubctl"
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
    PATH="$BATS_RUN_TMPDIR:$DIR/../bin:$PATH"

    HUB_OPTS="$BATS_RUN_TMPDIR/hub.elaborate -s $BATS_RUN_TMPDIR/hub.state"
}


@test "hubctl stack deploy: new syntax usage" {
    run hub-stack-deploy --help
    assert_success
    assert_line -p "hubctl stack deploy foo"
    assert_line -p "hubctl stack deploy foo,bar"
    assert_line -p "hubctl stack deploy ...foo"
    assert_line -p "hubctl stack deploy foo..."
    assert_line -p "hubctl stack deploy foo...bar"
}

@test "hubctl stack deploy: deploy full stack" {
    cd "$BATS_RUN_TMPDIR"

    run hub-stack-deploy
    assert_line -p "hubctl elaborate hub.yaml -o $BATS_RUN_TMPDIR/hub.elaborate"
    assert_line -p "hubctl deploy $HUB_OPTS"
    assert_success
}

@test "hubctl stack deploy: new syntax" {
    cd "$BATS_RUN_TMPDIR"

    run hub-stack-deploy dummy1
    assert_success
    assert_line -p "hubctl deploy $HUB_OPTS -c dummy1"

    run hub-stack-deploy dummy1,dummy2
    assert_success
    assert_line -p "hubctl deploy $HUB_OPTS -c dummy1,dummy2"

    # right now we do not support this syntax
    run hub-stack-deploy dummy1 dummy2
    assert_failure

    run hub-stack-deploy dummy1...
    assert_success
    assert_line -p "hubctl deploy $HUB_OPTS -o dummy1"

    run hub-stack-deploy ...dummy1
    assert_success
    assert_line -p "hubctl deploy $HUB_OPTS -l dummy1"

    run hub-stack-deploy dummy1...dummy2
    assert_success
    assert_line -p "hubctl deploy $HUB_OPTS -o dummy1 -l dummy2"

    # actually ... is an alias for .., so this is the same as above
    run hub-stack-deploy dummy1..dummy2
    assert_success
    assert_line -p "hubctl deploy $HUB_OPTS -o dummy1 -l dummy2"


    run hub-stack-deploy dummy1,dummy2...dummy3
    assert_success
    assert_line -p "hubctl deploy $HUB_OPTS -c dummy1,dummy2 -o dummy2 -l dummy3"
}

teardown() {
    cd "$DIR"
}
