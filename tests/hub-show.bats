#!./bats/bin/bats
# Copyright (c) 2023 EPAM Systems, Inc.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

gen_hubctl_double() {
    mkdir -p "$1"
    cat <<EOF > "$1/hubctl"
#!/bin/sh

if test "\$1" = "explain"; then
    cat $2
    exit 0
fi

echo ">> hubctl \$@"
EOF
    chmod +x "$1/hubctl"
}

get_stack() {
    mkdir -p "$1"
    cat <<EOF > "$1/.env"
HUB_STATE="hub.state"
EOF
  touch $1/hub.state
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

    get_stack "$HUB_WORKDIR"
    gen_hubctl_double "$HUB_WORKDIR" "$CURRDIR/resources/state-eks.json"
}

@test "hubctl show show state of stack" {
    cd "$HUB_WORKDIR"
    run hub-show
    assert_success
    assert_line --partial "kind: stack"

    run hub-show --format json
    assert_success
    assert_line --partial '"kind": "stack"'

    run hub-show -- '.status.status'
    assert_success
    assert_line --partial 'incomplete'
}

@test "hubctl show should work from another directory" {
    refute test "$CURDIR" = "$HUB_WORKDIR"
    cd "$CURDIR"
    run hub-show

    assert_success
    assert_line --partial "kind: stack"
}

@test "hubctl show should split parameters into nested objects with -- arg" {
    run hub-show -- '.parameters.kubernetes.cluster.version'
    assert_success
    assert_line --partial '1.26'
}

@test "hubctl show should show state of component" {
    run hub-show network
    assert_success
    assert_line --partial "kind: component"

    run hub-show network -- '.parameters.hub.componentName'
    assert_success
    assert_line --partial 'network'

    run hub-show network -- '.outputs.cloud.vpc.id'
    assert_success
    assert_line --partial 'vpc-002f110bdfecff55b'
}


teardown() {
    # if still trapped in another directory
    cd "$CURRDIR"
}
