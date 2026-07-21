import { argv, exit } from "node:process";
import * as p64cc from "./AsmLibrary/Pulsar64CCompiler.js";
import * as fileSystem from "node:fs";

let asmFile = argv[2];
let outpudFile = argv[3];
let asmFileContent = fileSystem.readFileSync(asmFile, 'utf-8');
let tok = p64cc.tokenize(asmFileContent);
let par = p64cc.parse(tok);
let result = p64cc.codeGen(par);

fileSystem.writeFileSync(outpudFile, result);