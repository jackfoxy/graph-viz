const fs = require('node:fs');
const http = require('node:http');
const os = require('node:os');
const path = require('node:path');
const {spawn} = require('node:child_process');

const root = path.resolve(__dirname, '../../..');

function read(relative) {
  return fs.readFileSync(path.join(root, relative), 'utf8')
    .replace(/^\/[+-].*\n/gm, '');
}

function findVere() {
  const candidates = [
    process.env.VERE,
    path.join(os.homedir(), 'piers/vere-v4.5-linux-x86_64'),
    path.join(os.homedir(), 'piers/urbit'),
    'vere'
  ].filter(Boolean);
  for (const candidate of candidates) {
    if (!candidate.includes('/') || fs.existsSync(candidate)) return candidate;
  }
  throw new Error('set VERE to an executable that supports `eval`');
}

function decodeCord(source) {
  const chunks = [];
  for (let index = 0; index < source.length;) {
    if (source[index] !== '\\') {
      const point = source.codePointAt(index);
      const character = String.fromCodePoint(point);
      chunks.push(Buffer.from(character));
      index += character.length;
      continue;
    }
    const hex = source.slice(index + 1, index + 3);
    if (/^[0-9a-f]{2}$/i.test(hex)) {
      chunks.push(Buffer.from([Number.parseInt(hex, 16)]));
      index += 3;
      continue;
    }
    if (index + 1 >= source.length) throw new Error('invalid cord escape');
    chunks.push(Buffer.from(source[index + 1]));
    index += 2;
  }
  return Buffer.concat(chunks).toString('utf8');
}

function parseCords(output) {
  const plain = output.replace(/\x1b\[[0-9;]*m/g, '');
  const start = plain.indexOf('eval (run):');
  if (start < 0) throw new Error('vere eval returned no result');
  const cords = [];
  let index = start;
  while (index < plain.length && cords.length < 2) {
    if (plain[index] !== "'") {
      index += 1;
      continue;
    }
    index += 1;
    let encoded = '';
    while (index < plain.length) {
      if (plain[index] === "'") {
        index += 1;
        break;
      }
      if (plain[index] === '\\') {
        encoded += plain[index];
        index += 1;
        if (index >= plain.length) throw new Error('unterminated cord');
        encoded += plain[index];
        if (/[0-9a-f]/i.test(plain[index])
          && /[0-9a-f]/i.test(plain[index + 1] || '')) {
          index += 1;
          encoded += plain[index];
        }
        index += 1;
        continue;
      }
      encoded += plain[index];
      index += 1;
    }
    cords.push(decodeCord(encoded));
  }
  if (cords.length !== 2) throw new Error('vere eval returned invalid assets');
  return cords;
}

function evaluate(source) {
  return new Promise((resolve, reject) => {
    const child = spawn(findVere(), ['eval']);
    const output = [];
    child.stdout.on('data', (chunk) => output.push(chunk));
    child.stderr.on('data', (chunk) => output.push(chunk));
    child.on('error', reject);
    child.on('close', (status) => {
      const result = Buffer.concat(output).toString('utf8');
      if (status === 0) resolve(result);
      else reject(new Error(result || 'vere eval failed'));
    });
    child.stdin.end(source);
  });
}

async function compileAssets() {
  const source = [
    '=+  ^=  gg',
    read('desk/sur/graph.hoon'),
    '=+  ^=  gviz',
    read('desk/sur/gviz.hoon'),
    '=+  ^=  web',
    read('desk/lib/gviz-web.hoon'),
    '[page:web javascript:web]'
  ].join('\n');
  return parseCords(await evaluate(source));
}

async function main() {
  const [page, javascript] = await compileAssets();
  const server = http.createServer((request, response) => {
    if (request.method === 'GET'
      && (request.url === '/apps/graph-viz'
        || request.url === '/apps/graph-viz/')) {
      response.writeHead(200, {'content-type': 'text/html; charset=utf-8'});
      response.end(page);
      return;
    }
    if (request.method === 'GET'
      && request.url === '/apps/graph-viz/app.js') {
      response.writeHead(200, {
        'content-type': 'text/javascript; charset=utf-8'
      });
      response.end(javascript);
      return;
    }
    response.writeHead(404, {'content-type': 'text/plain; charset=utf-8'});
    response.end('not found');
  });
  server.listen(4173, '127.0.0.1');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
