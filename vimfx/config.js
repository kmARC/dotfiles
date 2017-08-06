console.log('This is vimfx: ', vimfx);

let QuickMarks = [
  ['w', "https://meteo.search.ch/zurich"],
  ['r', "https://digg.com/reader"],
  ['t', "https://twitter.com"],
  ['y', "https://youtube.com"],
  ['i', "https://hubnet.nationalfield.com/group/107/impact-hub-zürich"],
  ['p', "https://www.postfinance.ch/ap/ba/fp/html/e-finance/home"],
  ['a', "https://docs.google.com/spreadsheets/d/1dk67cmm4gv52XTVJZWHpjJ8Thd0O2ZI8aBeOAWhvYI4/edit"],
  ['f', "https://facebook.com"],
  ['g', "https://github.com/kmARC"],
  ['h', "https://hup.hu/tracker/3464"],
  ['k', "https://keep.google.com"],
  ['l', "https://www.linkedin.com"],
  ['c', "https://eservice.cembra.ch/internetbanking/?login&language=de"],
  ['b', "https://docs.google.com/spreadsheets/d/1OxnkfzxDTO0KgESQqf2BN6_-hQyLLbjMbMdOoATu0ts/edit"],
  ['m', "https://www.magnetbank.hu/NetBank/ugyfel/index.xhtml"],
]

for (idx in QuickMarks) {
  let qm = QuickMarks[idx];
  addQuickMark(qm[0], qm[1]);
}

function addQuickMark(key, url) {
  vimfx.addCommand({
    name: 'go_' + key,
    description: url
  }, ({vim}) => {
    vim.window.gBrowser.loadURI(url);
  })
  vimfx.set('custom.mode.normal.go_' + key, 'go' + key)

  vimfx.addCommand({
    name: 'gn_' + key,
    description: url
  }, ({vim}) => {
    vim.window.gBrowser.loadOneTab(url, {inBackground: false});
  })
  vimfx.set('custom.mode.normal.gn_' + key, 'gn' + key)
}


