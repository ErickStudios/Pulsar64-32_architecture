export function tokenize(code) {
  const tokens = [];
  let i = 0;
  const isLetter = (c) => /[a-zA-Z_]/.test(c);
  const isNumber = (c) => /[0-9]/.test(c);
  while (i < code.length) {
    let c = code[i];
    if (/\s/.test(c)) {
      i++;
      continue;
    }
    if (c === "/" && code[i + 1] === "/") {
      while (i < code.length && code[i] !== "\n") {
        i++;
      }
      continue;
    }
    if (c === '-' && code[i + 1] === '>') {
        i+=2;
        tokens.push({ type: "arrow", value: '->' });

        continue;
    }
    if (c === "0" && (code[i + 1] === "x" || code[i + 1] === "X")) {
        i += 2;

        let value = "";

        while (
            i < code.length &&
            (isNumber(code[i]) || "ABCDEFabcdef".includes(code[i]))
        ) {
            value += code[i++];
        }

        tokens.push({
            type: "number",
            value: parseInt(value, 16)
        });

        continue;
    }
    if (c === "'") {
      let quoteType = c;
      let value = "";
      i++;
      while (i < code.length && code[i] !== quoteType) {
        value += code[i++];
      }
      i++;
      tokens.push({ type: "number", value: value.charCodeAt(0) });
      continue;
    }
    if (c === '"' || c === "'") {
        let quoteType = c;
        let value = "";
        i++;
        while (i < code.length && code[i] !== quoteType) {
            value += code[i++];
        }
        i++;
        tokens.push({ type: "string", value });
        continue;
    }
    if (isLetter(c)) {
      let value = "";
      while (i < code.length && (isLetter(code[i]) || isNumber(code[i]))) {
        value += code[i++];
      }
      tokens.push({ type: "identifier", value });
      continue;
    }
    if (isNumber(c)) {
        let value = "";

        while (
            i < code.length &&
            (
                isNumber(code[i]) ||
                "ABCDEFabcdef".includes(code[i])
            )
        ) {
            value += code[i++];
        }

        if (
            i < code.length &&
            code[i].toLowerCase() === "h"
        ) {
            i++;
            value = parseInt(value, 16);
        }
        else if (value === "0" && code[i] === "x") {
          i++;
          let value2 = "";
          while (i < code.length && (isNumber(code[i]) || ['A','B','C','D','E','F'].includes(code[i].toUpperCase()))) {
            value2 += code[i++];
          }
          value = parseInt(value2, 16);
        }
        else {
            value = Number(value);
        }

        tokens.push({
            type: "number",
            value
        });

        continue;
    }
    if (c === '=' && code[i + 1] === '=') {
        i+=2;
        tokens.push({ type: "symbol", value: '==' });
        continue;
    }
    if (c === '!' && code[i + 1] === '=') {
        i+=2;
        tokens.push({ type: "symbol", value: '!=' });
        continue;
    }
    if (c === '<' && code[i + 1] === '<') {
        i+=2;
        tokens.push({ type: "symbol", value: '<<' });
        continue;
    }
    if (c === '>' && code[i + 1] === '>') {
        i+=2;
        tokens.push({ type: "symbol", value: '>>' });
        continue;
    }
    tokens.push({ type: "symbol", value: c });
    i++;
  }
  return tokens;
}

export class IrInstruction {
    constructor(name, ps) {
        this.name = name;
        this.ps = ps;
    }
    getType() {
        return this.name;
    }
    toString() {
        return this.name + " " + this.ps.join(",");
    }
}

/** @param {{type: string;value: number | string;}[]} tokens  */
export function parse(tokens) {
    let i = 0;
    let functions = {};
    let variables = {};
    let structs = {};

    function peek() {
        return tokens[i];
    }
    function consume() {
        let a = peek();
        i++;
        return a;
    }
    function expect(value) {
        let t = consume();
        if (!t || t.value !== value) {
        throw new Error("Expected " + value);
        }
    }
    function isFunction() {
        let save = i;

        if (!isType(peek().value)) {
            return false;
        }

        consume(); // tipo

        if (peek().type !== "identifier") {
            i = save;
            return false;
        }

        consume();

        let result = peek().value === "(";

        i = save;
        return result;
    }
    function parseFunction(saveBody=true, nameV='xd', retiv='char') {
    
        let returnType = retiv;
        let name = nameV
        if (saveBody) {
            returnType = consume().value;
            name = consume().value;
        }

        expect("(");

        let params = [];

        while (peek().value !== ")") {

            if (peek().value === 'struct') consume();

            let type = consume().value;

            let pointer = false;
            if (peek().value === "*") {
                consume();
                pointer = true;
            }

            let param = consume().value;

            params.push({
                name: param,
                type,
                pointer
            });

            if (peek().value === ",")
                consume();
        }

        expect(")");
        let ssa = Symbol(0);
        let offset = 0;

        for (const p of params) {
            variables[p.name] = {
                type: p.type,
                pointer: p.pointer,
                parameter: true,
                offset,
                pp: ssa
            };

            offset += 8;
        }
        let body = [];
        if (saveBody) {
            expect("{");

            while (peek().value !== "}") {
                body.push(...inCodeSpace());
            }

            expect("}");

        }

        Object.keys(variables)
            .filter(a => variables[a].pp === ssa)
            .forEach(a => delete variables[a]);

        let fn = {
            type: "Function",
            name : saveBody ? name : nameV,
            returnType: saveBody ? returnType : retiv,
            params,
            body : saveBody ? body : [],
            sas: offset
        };

        functions[saveBody ? name : nameV] = fn;

        return new IrInstruction("Function", [fn]);
    }
    function loadPointer() {
        return new IrInstruction('Desreference', []);
    }
    function loadValue(name) {
        let v = variables[name];

        if (v?.parameter)
            return new IrInstruction("LoadParameter", [v.offset, getTypeSize(v.type)]);

        return new IrInstruction("LoadValue", [name]);
    }
    function loadField(offset) {
        return new IrInstruction('Field', [offset])
    }
    function getSize(field) {

        if (field.pointer)
            return 8;


        if (field.type === "long")
            return 8;
        if (field.type === "int")
            return 4;
        if (field.type === "short")
            return 2;
        if (field.type === "char")
            return 1;
        if (field.type === "bool")
            return 1;

        return structs[field.type]?.size ?? 0;
    }
    function calcStructSize(fields) {
        let size = 0;

        for (const field of fields) {
            size += getSize(field);
        }

        return size;
    }
    function isType(name) {
        return (
            name === "long" ||
            name === "int" ||
            name === "short" ||
            name === "char" ||
            name === "bool" ||

            structs[name]
        );
    }
    function variableReference() {

        let ir = [];
        let deref = false;

        if (peek().value === "*") {
            consume();
            deref = true;
        }


        let name = consume().value;

        let variable = variables[name];

        let currentType = variable.type;

        let ab = loadValue(name);
    
        let msr = false;
        if (ab.getType() == 'LoadParameter') {
            msr = true;
        }

        ir.push(ab);

        if (deref && !msr) {
            ir.push(loadPointer());
        }

        let levelo = 0;
        while (peek() &&
            (peek().value === "." ||
            peek().value === "->")) {

            let op = consume().value;
            let field = consume().value;

            if (op === "->") {
                if (levelo == 0 && msr) {

                }
                else ir.push(loadPointer());
            }

            levelo++;

            let offset = getFieldOffset(
                currentType,
                field
            );

            ir.push(loadField(offset));


            let fieldInfo =
                structs[currentType]
                .fields
                .find(f => f.name === field);


            currentType = fieldInfo.type;
        }

        let pointer = variable.pointer;

        if (deref) {
            if (!pointer)
                throw new Error("Cannot dereference non-pointer");

            pointer = false;
        }

        return {
            ir,
            type: currentType,
            pointer: pointer,
            deref,
            msr
        };
    }
    function parseVariableDecl(addFile=true, externed=false) {
        let type = consume().value;

        let pointer = false;

        if (peek().value === '*') {
            consume();
            pointer = true;
        }

        let name = consume().value;

        if (externed) {
            if (peek().value == '(') {
                parseFunction(false, name, type);
                expect(";");
                return;

            }
        }

        expect(";");

        variables[name] = {
            type,
            pointer
        };

        if (addFile) {
            return new IrInstruction(
                "Declare",
                [
                    name,
                    type,
                    pointer ? 8 : getTypeSize(type),
                    8
                ]
            );
        }
    }
    function getFieldOffset(structName, fieldName) {

        let st = structs[structName];

        let offset = 0;

        for (let f of st.fields) {
            if (f.name === fieldName)
                return offset;

            offset += getSize(f);
        }

        throw new Error("field not found");
    }
    function parseReturn() {
        let ir = [];
        expect("return");
        ir.push(new IrInstruction("ChgPrimRe", []));
        ir.push(...parseSymbol().ir);
        ir.push(new IrInstruction("ExitFunction", []));
        expect(";");
        return ir;
    }

    function parseSymbol() {

        if (peek().value === "&") {
            consume();

            let ref = variableReference();

            return {
                ir: ref.ir,
                type: ref.type,
                pointer: true
            };
        }

        if (peek().type === 'number') {
            return {
                ir:[
                    new IrInstruction(
                        'LoadFlat',
                        [consume().value]
                    )
                ],
                type:'long',
                pointer:false
            };
        }

        let a = variableReference();
        if (!a.msr) 
        a.ir.push(
            new IrInstruction(
                'Get',
                [
                    a.pointer ? 8 : getTypeSize(a.type)
                ]
            )
        );

        return a;
    }

    function newLabel(name) {
        return name + "_" + Math.floor(Math.random()*10000);
    }

    function getTypeSize(type) {

        if (type === "long")
            return 8;

        if (type === "int")
            return 4;

        if (type === "short")
            return 2;

        if (type === "char")
            return 1;


        return structs[type]?.size ?? 0;
    }
    function parseCall() {

        let name = consume().value;

        expect("(");

        let args = [];

        while (peek().value !== ")") {

            let arg = parseSymbol();

            args.push(arg);

            if (peek().value === ",")
                consume();
        }

        expect(")");

        expect(";");


        return [
            new IrInstruction(
                "Call",
                [
                    name,
                    args
                ]
            )
        ];
    }
    function inCodeSpace() {
        if (peek().value === "return") {
            return parseReturn();
        }

        if (peek().value === '__asm__') {
            consume();
            expect("(");
            let v = consume().value;
            expect(")");
            expect(";");
            return [new IrInstruction('AsmInsert', [v])];
        }

        if (peek().value === "while") {
            return parseWhile();
        }

        if (peek().value === 'if') {
            return parseIf();
        }

        if (
            peek().type === "identifier" &&
            tokens[i + 1]?.value === "("
        ) {
            return parseCall();
        }
        
        let boda = [new IrInstruction('ChgPrimRe', [])];
        let ab = variableReference();
        boda.push(...ab.ir);
        if (peek().value == '=') {
            consume();
            boda.push(new IrInstruction('ChgSecRe', []));
            let s = parseSymbol();
            boda.push(...s.ir);
            let modifier = "";
            let symbols = {
                '+': 'Add',
                '-': 'Sub',
                '*': 'Mul',
                '/': 'Div',
                '<<': 'Shl',
                '>>': 'Shr',
                '&' : 'And'
            }
            if (peek().value !== ';') {
                if (peek().value in symbols) {
                    modifier = symbols[consume().value];
                }
            }
            if (modifier !== '') {
                let d = parseSymbol();
                boda.push(new IrInstruction('ChgTerRe', []));
                boda.push(...d.ir);
                boda.push(new IrInstruction(`${modifier}`));
            }
            boda.push(new IrInstruction(`Store`, [
                ab.pointer ? 8 : getTypeSize(ab.type),
                s.pointer ? 8 : getTypeSize(s.type)
            ]));

        }
        expect(";");
        return boda;
    }
    function parseCondition(){

        let ada = [];
        
        ada.push(new IrInstruction('ChgPrimRe', []));
        let left = parseSymbol();
        ada.push(...left.ir);

        let op = consume().value;

        ada.push(new IrInstruction('ChgSecRe', []));
        let right = parseSymbol();
        ada.push(...right.ir);

        ada.push(new IrInstruction("Compare",[op]))

        return {
            ir:ada
        };
    }
    function parseWhile(){

        expect("while");
        expect("(");

        let condition = parseCondition();

        expect(")");
        expect("{");

        let body=[];

        while(peek().value !== "}") {
            body.push(...inCodeSpace());
        }

        expect("}");


        let start = newLabel("while");
        let end = newLabel("end");


        return [
            new IrInstruction(
                "Label",
                [start]
            ),

            ...condition.ir,

            new IrInstruction(
                "JumpFalse",
                [end]
            ),

            ...body,

            new IrInstruction(
                "Jump",
                [start]
            ),

            new IrInstruction(
                "Label",
                [end]
            )
        ];
    }
    function parseIf(){

        expect("if");
        expect("(");

        let condition = parseCondition();

        expect(")");
        expect("{");

        let body=[];

        while(peek().value !== "}") {
            body.push(...inCodeSpace());
        }

        expect("}");


        let start = newLabel("if");
        let end = newLabel("endif");


        return [
            new IrInstruction(
                "Label",
                [start]
            ),

            ...condition.ir,

            new IrInstruction(
                "JumpFalse",
                [end]
            ),

            ...body,

            new IrInstruction(
                "Label",
                [end]
            )
        ];
    }
    function inDataSpace() {
        if (isFunction()) {return [parseFunction()];}
        if (peek().value === 'extern') {
            consume();
            parseVariableDecl(false, true);
            return [];
        }
        if (peek().value === 'struct') {
            let ac = parseStruct();
            if (ac) 
                return [new IrInstruction('CrtStruct', [ac])];
            else {
                i--;
                return inDataSpace();
            }
        }
        if (peek().type === "identifier" &&
        isType(peek().value)) {
            return [
                parseVariableDecl()
            ];
        }
    }

    function parseStruct() {
        expect("struct");

        const name = consume().value;

        if (peek().value !== '{') return null;
        expect("{");

        const fields = [];

        while (peek().value !== "}") {

            if (peek().value === 'struct') consume();

            let type = consume().value;

            let pointer = false;

            if (peek().value === "*") {
                consume();
                pointer = true;
            }

            let field = consume().value;

            expect(";");

            fields.push({
                name: field,
                type,
                pointer
            });
        }

        expect("}");
        expect(";");


        let result = {
            type: "Struct",
            name,
            fields,
            size: calcStructSize(fields)
        };

        structs[name] = result;

        return result;
    }

    function parseProgram() {
        let ir = [];

        while (peek()) {

            let pk = inDataSpace();
            if (!pk) {
                pk = inCodeSpace();
            }

            if (!pk) pk = [];

            ir.push(...pk);
        }

        return ir;
    }

    return parseProgram();
}
/** @param {IrInstruction[]} pparsed  */
export function codeGen(pparsed) {
    let secondary = 0;
    function mainReg() {
        return `r${secondary}`
    }
    let xas = {
        1: 'byte',
        2: 'word',
        4: 'dword',
        8: 'qword'
    }
    /** @param {IrInstruction} p  */
    function genB(p) {
        if (p.getType() === 'ChgPrimRe') {
            secondary = 0;
        }
        else if (p.getType() === 'ChgSecRe') {
            secondary = 1;
        }
        else if (p.getType() === 'ChgTerRe') {
            secondary = 2;
        }
        else if (p.getType() === 'LoadValue') {
            return `li64 ${mainReg()}, ${String(p.ps[0])}`;
        }
        else if (p.getType() === 'Field') {
            if (p.ps[0] !== 0)
                return `add ${mainReg()}, ${mainReg()}, ${String(p.ps[0])}`;
            
            return "";
        }
        else if (p.getType() === 'Desreference') {
            return `mov ${mainReg()}, [qword ${mainReg()}]`;
        }
        else if (p.getType() === 'Store') {
            return `mwr${String(p.ps[0] * 8)} r0, r1`;
        }
        else if (p.getType() === 'Add') {
            return `add r1, r1, r2`;
        }
        else if (p.getType() === 'Sub') {
            return `sub r1, r1, r2`;
        }
        else if (p.getType() === 'Div') {
            return `div r1, r1, r2`;
        }
        else if (p.getType() === 'Mul') {
            return `mul r1, r1, r2`;
        }
        else if (p.getType() === 'Shl') {
            return `shl r1, r1, r2`;
        }
        else if (p.getType() === 'Shr') {
            return `shr r1, r1, r2`;
        }
        else if (p.getType() === 'And') {
            return `and r1, r1, r2`;
        }
        else if (p.getType() === 'LoadFlat') {
            return `li64 ${mainReg()}, ${String(p.ps[0])}`;
        }
        else if (p.getType() === 'Get') {
            return `lv${String(p.ps[0] * 8)} ${mainReg()}, ${mainReg()}`
        }
        else if (p.getType() === 'Declare') {
            return `${p.ps[0]}: reserve ${p.ps[2]}`;
        }
        else if (p.getType() === 'LoadParameter') {
            return `mov ${mainReg()}, [qword bp-${p.ps[0]}]`;
            // ${xas[p.ps[1]]}
        }
        else if(p.getType()==="Label"){
            return p.ps[0]+":";
        }
        else if(p.getType()==="Jump"){
            return `jmp ${p.ps[0]}`;
        }
        else if(p.getType()==="JumpTrue"){
            return `jifeq ${p.ps[0]}`;
        }
        else if(p.getType()==="AsmInsert") {
            return p.ps[0];
        }
        else if(p.getType()=='ExitFunction') {
            let out = [];
            out.push("leave");
            out.push("   ret");
            return out.join("\n");
        }
        else if(p.getType()==="JumpFalse"){
            return `cmp r2, r2, 0 jifeq ${p.ps[0]}`;
        }
        else if (p.getType() === 'Compare') {
            return `cmp r2, r0, r1`
        }
        else if (p.getType() === "Call") {

            let name = p.ps[0];
            let args = p.ps[1];

            let out = [];

            let argn = 0;

            for (let arg of args) {

                for (let ins of arg.ir) {
                    out.push((argn !== 0 ? `   ` : "") + genA(ins));
                    argn++;
                }

                out.push(
                    `   push ${mainReg()}`
                );

                argn++;
            }

            out.push(
                (argn !== 0 ? `   ` : "") + `bl ${name}`
            );

            out.push(
                `   add sp, sp, ${args.length*8}`
            )

            return out.filter(x => x.trim() !== "").join("\n");
        }
        else if (p.getType() === "Function") {
            let fn = p.ps[0];

            let out = [];

            out.push(`${fn.name}:`);
            let v = ((fn.sas/8)-1)*8;
            if (!(v >= 0)) v = 0;
            out.push(`   enter ${v}`);

            for (let ins of fn.body) {
                out.push((ins.getType() !== 'Label' ? "   " : "") + genA(ins));
            }

            out.push("   leave");
            out.push("   ret");

            return out.filter(x => x.trim() !== "").join("\n");
        }
        return '';
    }
    function genA(p) {
        return genB(p) //+ "; "+ p.getType();
    }

    return pparsed.map(genA).filter(x => x.trim() !== "").join("\n");
}
/*
let abc = pparse(tokenize(`
    struct tc {
        long w;
    };
    struct tb {
        long a;
        int b;
        struct tc z;
    };
    struct ta {
        struct tc aa;
        struct tb za;
        struct tb* y;
        struct tc a;
    };
    struct ta x;
    x.y->z.w = x.a;
    `));
console.log(codeGen(abc));
*/