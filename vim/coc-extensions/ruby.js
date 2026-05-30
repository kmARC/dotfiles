const { commands, workspace } = require('coc.nvim')

exports.activate = context => {
  let { nvim } = workspace
  context.subscriptions.push(commands.registerCommand('rubyLsp.openFile', async (uris) => {
    await nvim.call('coc#util#open_file', ["edit", uris[0]])
  }))
}
