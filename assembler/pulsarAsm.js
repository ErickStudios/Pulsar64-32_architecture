import { argv, exit } from "node:process";
import {LibraryAssembler as p3264asm } from "./asm.js";
import * as fileSystem from "node:fs";

let asmFile = argv[2];
let outpudFile = argv[3];
let asmFileContent = fileSystem.readFileSync(asmFile, 'utf-8');
let resulta = p3264asm.asm.assembleCode(asmFileContent);
let result = resulta.result;
let hex = result.map(b => b.toString(16).padStart(2, '0')).join('\n');
if (argv.includes("-d")) {
    hex = result.map(b => b.toString()).join('\n');
}
else if (argv.includes("-rbin")) {
    fileSystem.writeFileSync(outpudFile, Buffer.from(result));
    exit(0);
}

fileSystem.writeFileSync(outpudFile, hex);