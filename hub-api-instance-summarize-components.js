// Copyright (c) 2022 EPAM Systems, Inc.
// 
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

const fs = require('fs');
const {sortBy} = require('lodash');

const input = fs.readFileSync(0, 'utf-8');
if (!input.length) process.exit(0);
const json = JSON.parse(input);
const instances = Array.isArray(json) ? json : [json];

const table = {};

instances.forEach((instance) => {
    const {components = []} = instance.status || {};
    components.forEach(({name, meta: {origin, version = '<none>'}}) => {
        const trueName = origin || name;
        const comp = table[trueName] || {};
        const compVersion = comp[version] || [];
        compVersion.push(instance.domain);
        comp[version] = compVersion;
        table[trueName] = comp;
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
