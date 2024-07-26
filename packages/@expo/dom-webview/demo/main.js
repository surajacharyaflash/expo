async function runAsync() {
  const source = 'JSON.stringify(globalThis.HermesInternal.getRuntimeProperties(), null, 2)';
  const result = await evalAsync(source);
  document.getElementById('result-async').innerHTML = prettyJSON(result);
}

function runSync() {
  const source = 'globalThis.expo.modules.ExponentConstants.manifest';
  const result = evalSync(`JSON.stringify(${source}, null, 2)`);
  document.getElementById('result-sync').innerHTML = prettyJSON(result);
}

function prettyJSON(json) {
  return JSON.stringify(JSON.parse(json), null, 2).replace(/\n/g, '<br>').replace(/ /g, '&nbsp;');
}

async function evalAsync(source) {
  return await window.webkit.messageHandlers.evalAsync.postMessage(source);
}

function evalSync(source) {
  return window.prompt(source);
}
