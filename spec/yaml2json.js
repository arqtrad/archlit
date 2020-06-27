const fs = require('fs')
const YAML = require('yaml')
var args = process.argv.slice(2);
const file = fs.readFileSync(args[0], 'utf8')
var timeline_json = YAML.parse(file);
console.log(timeline_json);
