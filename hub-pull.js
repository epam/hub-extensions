const fs = require('fs');
const url = require('url');
const yaml = require('js-yaml');
const {difference, get, isEmpty, kebabCase, partition, trimEnd, uniq, uniqBy} = require('lodash');

function usage(code = 1) {
    console.log('`hub pull -h` for help');
    process.exit(code);
}

function parseArgs() {
    const known = ['components', 'show', 'debug', 'trace', 'force'];
    const argv = [];
    const opts = {};
    let skip = false;
    process.argv.slice(2).forEach((arg, i, args) => {
        if (arg.startsWith('--')) {
            const [k, v = true] = arg.substr(2).split('=');
            opts[k] = v;
        } else if (arg.startsWith('-')) {
            let k = arg.substr(1);
            k = known.find((w) => w.startsWith(k)) || k;
            let v = args[i + 1];
            skip = true;
            if (!v || (v && v.startsWith('-'))) v = true;
            opts[k] = v;
        } else {
            if (!skip) argv.push(arg);
            skip = false;
        }
    });
    const extra = difference(Object.keys(opts), known);
    if (extra.length) {
        console.log(`error: unknown command-line argument: ${extra.join(' ')}`);
        usage();
    }
    if (opts.trace) opts.debug = true;
    if (opts.components) opts.components = opts.components.split(',');
    return {argv, opts};
}

const {argv, opts} = parseArgs();
if (opts.trace) {
    console.log(argv);
    console.log(opts);
}
const manifestFilename = argv[0] || 'hub.yaml';
const worktree = argv[1];
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

const {components = []} = manifest;
const sources = (opts.components ? components.filter(({name}) => opts.components.includes(name)) : components)
    .map(({name, source}) => ({...source, name}))
    .filter(({name, dir, git}) => name && dir && get(git, 'remote'));

const remotes = uniq(sources.map(({git: {remote}}) => remote));
const remoteBranches = uniqBy(
    sources.map(({git: {remote, ref = 'master'}}) => ({remote, ref})),
    ({remote, ref}) => `${remote}|${ref}`);
const [splits, singles] = partition(sources, ({git: {subDir}}) => subDir);

let cmds = ['set -xe'];

if (!opts.debug) cmds.push('\nif ! test -t 1; then subtree_flags=-q; fi');

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
