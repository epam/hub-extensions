const fs = require('fs');
const {sortBy} = require('lodash');

const input = fs.readFileSync(0, 'utf-8');
if (!input.length) process.exit(0);
const json = JSON.parse(input);
const instances = Array.isArray(json) ? json : [json];

const table = {};

instances.forEach((instance) => {
    const {components = []} = instance.status || {};
    // TODO use component `origin` instead of `name`
    components.forEach(({name, meta: {version = '<none>'}}) => {
        const comp = table[name] || {};
        const compVersion = comp[version] || [];
        compVersion.push(instance.domain);
        comp[version] = compVersion;
        table[name] = comp;
    });
});

// console.log(JSON.stringify(table));

sortBy(Object.entries(table), ([first]) => first).forEach(([name, comp]) => {
    console.log(`${name}:`);
    sortBy(Object.entries(comp), ([first]) => first).forEach(([version, domains]) => {
        console.log(`\t${version}:\t\t${sortBy(domains).join(', ')}`);
    });
    console.log('');
});
