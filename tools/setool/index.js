#!/usr/bin/env node

const chalk = require('chalk');
const { createModule } = require('./lib/create-module/generator');
const { createFunction } = require('./lib/create-function/generator');
const { findPathInfo } = require('./lib/utils');

console.log(chalk.yellow('Spatial Extension Tool'));

function help () {
    return `Available commands:
- setool create module
- setool create function`;
}

const run = async () => {
    const argv = process.argv.slice(2);

    const info = findPathInfo();

    if (argv[0] === 'create' && argv[1] === 'module') {
        await createModule(info);
        console.log(chalk.green('Module created!'));
    } else if (argv[0] === 'create' && argv[1] === 'function') {
        await createFunction(info);
        console.log(chalk.green('Function created!'));
    } else {
        console.log(help());
    }
};

run();