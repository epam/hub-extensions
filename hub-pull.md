`hub-pull` is to read `hub.yaml` `components[].source.git` stanzas and emit `git` shell commands to pull updates from upstream. The subtrees must be already in-place. To add new components - see below.

Usage:

    $ hub-pull [--help / -h] [--show / -s] [hub.yaml] [worktree]

Temporary `worktree` is necessary to perform subtree split for components that resides under `subDir` in a Git repo.

To add new component as Git subtree - for component occupying whole repository, for example:

    # add upstream remote
    git remote add github-com-agilestacks-tls-host-controller \
        https://github.com/agilestacks/tls-host-controller.git
    # fetch upstream branch
    git fetch github-com-agilestacks-tls-host-controller master
    # add subtree under tls-host-controller/ directory
    git subtree add --squash -m 'Add tls-host-controller' --prefix=tls-host-controller \
        github-com-agilestacks-tls-host-controller/master

To add new component as Git subtree - for component residing in a directory of a monorepo, for example:

    git remote add github-com-agilestacks-components \
        https://github.com/agilestacks/components.git
    git fetch github-com-agilestacks-components master
    # need a worktree for subtree split
    git worktree add /tmp/w1 --detach
    pushd /tmp/w1
    git checkout -B upstream/github-com-agilestacks-components-master \
        github-com-agilestacks-components/master
    # extract components sources from subdirectories into `split` branch
    git subtree split --prefix=postgresql -b split/postgresql
    popd
    # stash worktree before subtree merge
    git stash save -a
    # add subtree under components/postgresql/ directory
    git subtree add --squash -m 'Add postgresql' --prefix=components/postgresql \
        split/postgresql
    git stash pop
