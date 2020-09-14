const fs = require('fs');
const url = require('url');
const yaml = require('js-yaml');
const {get, isEmpty, kebabCase, partition, trimEnd, uniq, uniqBy} = require('lodash');

const manifestFilename = process.argv[2] || 'hub.yaml';
const worktree = process.argv[3];
const tmpDir = process.env.TMPDIR;
const worktreePrefix = 'hub-pull';
const worktreeDirPrefix = `${trimEnd(tmpDir, '/') || '/var/tmp'}/${worktreePrefix}`;
const worktreeTemplate = `${worktreeDirPrefix}.XXXXXX`;

const manifest = yaml.safeLoad(fs.readFileSync(manifestFilename));

const remoteName = (remote) => {
    const u = url.parse(remote);
    return kebabCase(`${u.host}/${u.path}`);
};
const remoteBranchName = (remote, ref) => `${remoteName(remote)}/${ref}`;
const localBranchName = (remote, ref) => `upstream/${remoteName(remote)}-${ref}`;
const splitBranchName = (componentName) => `split/${kebabCase(componentName)}`;

const sources = (manifest.components || [])
    .map(({name, source}) => ({...source, name}))
    .filter(({name, dir, git}) => name && dir && get(git, 'remote'));

const remotes = uniq(sources.map(({git: {remote}}) => remote));
const remoteBranches = uniqBy(
    sources.map(({git: {remote, ref = 'master'}}) => ({remote, ref})),
    ({remote, ref}) => `${remote}|${ref}`);
const [splits, singles] = partition(sources, ({git: {subDir}}) => subDir);

let cmds = ['set -xe'];

cmds.push('\nif ! test -t 1; then subtree_flags=-q; fi')

cmds.push('\n# add upstream remotes');
cmds = cmds.concat(remotes.map((remote) =>
    `if ! git remote | grep -E '^${remoteName(remote)}$'; then\n\tgit remote add ${remoteName(remote)} ${remote}; fi`));

cmds.push('\n# fetch upstream branches with updates');
cmds = cmds.concat(remoteBranches.map(({remote, ref}) =>
    `git fetch ${remoteName(remote)} ${ref}`));

if (!isEmpty(splits)) {
    cmds.push('\n# need a worktree for subtree split');
    if (worktree) {
        cmds.push(`if ! git worktree list | grep -E '^${worktree} '; then`);
        cmds.push(`\tgit worktree add ${worktree} --detach; fi`);
        cmds.push(`pushd ${worktree}`);
    } else {
        cmds.push(`if ! git worktree list | grep -F '/${worktreePrefix}'; then`);
        cmds.push(`\tworktree=$(mktemp -d ${worktreeTemplate})`);
        cmds.push('\tgit worktree add $worktree --detach');
        cmds.push('else');
        cmds.push(`\tworktree=$(git worktree list | grep -F '/${worktreePrefix}' | head -1 | cut -d' ' -f1); fi`);
        cmds.push('pushd $worktree');
    }
    cmds.push('\n# extract components sources from subdirectories into `split` branches');
    // TODO optimize for a single `git checkout` per remote+ref combination
    cmds = cmds.concat(splits.map(({name, git: {remote, ref, subDir}}) =>
        `git checkout -B ${localBranchName(remote, ref)} ${remoteBranchName(remote, ref)}\n`
        + `git subtree $subtree_flags split --prefix=${subDir} -b ${splitBranchName(name)}`));
    cmds.push('popd');
}

cmds.push('\n# stash worktree before subtree merge');
cmds.push('git stash save -a');

if (!isEmpty(splits)) {
    cmds.push('\n# merge `split` branches');
    cmds = cmds.concat(splits.map(({name, dir}) =>
        `if test -d ${dir}; then verb=merge; else verb=add; fi\n`
        + `git subtree $subtree_flags $verb --squash -m "${name} $verb" --prefix=${dir} ${splitBranchName(name)}`));
}

if (!isEmpty(singles)) {
    cmds.push('\n# merge changes from repositiories with component source on top level');
    cmds = cmds.concat(singles.map(({dir, git: {remote, ref}}) =>
        `if test -d ${dir}; then verb=merge; else verb=add; fi\n`
        + `git subtree $subtree_flags $verb --squash -m "${dir} $verb" --prefix=${dir} ${remoteBranchName(remote, ref)}`));
}

cmds.push('git stash pop');

console.log(cmds.join('\n'));
