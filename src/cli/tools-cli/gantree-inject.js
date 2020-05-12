#!/usr/bin/env node

const program = require('commander')
const { inject } = require('../../tools/inject')

program
  .description('Injects keys into chainspec (non-raw).')
  .option('-c, --chainSpecPath [path]', 'Path to chainSpec file.')
  .option('-v, --validatorSpecPath [path]', 'Path to validatorSpec file.')
  .option(
    '-R, --allow-raw',
    'Allow usage of raw chainSpec (returns raw chainSpec in stdout)',
    false
  )
  .action(inject_CLI)

program.allowUnknownOption(false)

// const parsed = program.parse(process.argv)
program.parse(process.argv)

function inject_CLI(cmd) {
  let allowRaw = false
  if (cmd.chainSpecPath === undefined) {
    throw new Error('chainSpecPath missing')
  }
  if (cmd.validatorSpecPath === undefined) {
    throw new Error('validatorSpecPath missing')
  }
  if (!(cmd.allowRaw === undefined)) {
    allowRaw = cmd.allowRaw
  }

  inject(cmd.chainSpecPath, cmd.validatorSpecPath, allowRaw)
}
