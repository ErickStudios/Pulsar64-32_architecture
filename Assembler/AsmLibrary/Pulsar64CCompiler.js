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

export class CtxTempExp {
    constructor() {
        this.structs = {};
    }
};

/** @param {{type: string;value: number | string;}[]} tokens  */
export function parse(tokens, ctx=null) {
    let i = 0;
    let functions = {};
    let variables = {};
    let structs = {};
    let befvars = [];
    let endname = "";
    let funcinitvr;

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
        let fna = [];
        let nobj = {
            name,
            ir: fna,
            ssa,
            offsa: offset,
            params
        }
        let befa = funcinitvr;
        if (saveBody) {
            expect("{");

            while (peek().value !== "}") {
                funcinitvr = nobj;
                let oi = i;
                try {
                    let ab = inCodeSpace();
                    body.push(...ab);
                }
                catch (e) {
                    i = oi;
                    body.push(...inDataSpace());
                }
            }

            funcinitvr = befa;
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
            preb : fna,
            sas: offset,
            ses: nobj.offsa - offset
        };

        variables[name] = {
            type: 'long',
            pointer: true
        }
        functions[saveBody ? name : nameV] = fn;

        return new IrInstruction("Function", [fn]);
    }
    function loadPointer() {
        return new IrInstruction('Desreference', []);
    }
    function loadValue(name) {
        let v = variables[name];

        if ('offsata' in v) {
            let bc = [];
            bc.push(new IrInstruction("LoadFlat", [v.offsata]));
            bc.push(new IrInstruction("Inline", ["sub $$m, bp, $$m"]));
            return bc;
        }

        if (v?.parameter)
            return new IrInstruction("LoadParameter", [v.offset, getTypeSize(v.type)]);

        return new IrInstruction("LoadValue", [('altna' in v) ? v.altna : name]);
    }
    function loadField(offset) {
        return new IrInstruction('Field', [offset])
    }
    function getSize(field) {

        if (field.pointer || field.function)
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
        if (!Array.isArray(ab) && ab.getType() == 'LoadParameter') {
            msr = true;
        }

        ab = Array.isArray(ab) ? ab : [ab];
        ir.push(...ab);

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

            if (fieldInfo.function) {
                currentType = "function";
            }
            else {
                currentType = fieldInfo.type;
            }
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

        let stra = null;
        if (!externed && peek().value == '=') {
            consume();
            stra = consume().value;
        }

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

        if (funcinitvr) {
            variables[name].altna = "__" + funcinitvr.name + "_" + name;
            variables[name].pp = funcinitvr.ssa;
            variables[name].offsata = funcinitvr.offsa + 16 + (pointer ? 8 : getTypeSize(type));
            funcinitvr.offsa += (pointer ? 8 : getTypeSize(type))
        }

        if (addFile) {
            if (funcinitvr) {
                return new IrInstruction('Nop', [])
            }
            return new IrInstruction(
                "Declare",
                [
                    name,
                    type,
                    pointer ? 8 : getTypeSize(type),
                    8,
                    stra
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
        ir.push(new IrInstruction("ExitFunction", [funcinitvr.name + "__stdend"]));
        expect(";");
        return ir;
    }

    function parseSymbol() {

        if (peek().value in functions) {
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

        if (peek().value === 'sizeof') {
            consume();
            expect('(');
            let ptr = false;
            let name;
            if (peek().value === 'struct') consume();
            name = consume().value;
            if (peek().value === '*') {
                ptr = true;
                consume();
            }
            expect(')');
            return {
                ir:[
                    new IrInstruction(
                        'LoadFlat',
                        [ptr ? 8 : getSize(name)]
                    )
                ],
                type:'long',
                pointer:false
            };
        }

        let a = variableReference();
        if (a.type === 'function' || !a.msr) 
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

        if (type === 'function')
            return 8;

        return structs[type]?.size ?? 0;
    }
    function parseCall(tar=null) {

        let target = tar !== null ? tar : parseSymbol();

        expect("(");

        let args = [];

        while (peek().value !== ")") {

            let arg = parseSymbol();

            args.push(arg);

            if (peek().value === ",")
                consume();
        }

        expect(")");

        if (tar === null) expect(";");

        return [
            new IrInstruction(
                "Call",
                [
                    target.ir,
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

        if (peek().value === 'break') {
            consume();
            expect(';');
            return [new IrInstruction("Jump", [endname])]
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
        if (peek().value == '(') {
            if (ab.type === "function")
                ab.ir.push(loadPointer())
            boda.push(...parseCall(ab))
        }
        else if (peek().value == '=') {
            boda.push(...ab.ir);
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
        else if (peek().value == '+') {
            consume();
            if (peek().value == '+') {
                boda.push(...ab.ir);
                consume();
                boda.push(new IrInstruction('ChgSecRe', []));
                boda.push(...ab.ir);
                boda.push(new IrInstruction('Get',[ab.pointer ? 8 : getTypeSize(ab.type)]))
                boda.push(new IrInstruction('ChgTerRe', []));
                boda.push(new IrInstruction('LoadFlat',[1]));
                boda.push(new IrInstruction(`Add`));
                boda.push(new IrInstruction(`Store`, [
                    ab.pointer ? 8 : getTypeSize(ab.type),
                    ab.pointer ? 8 : getTypeSize(ab.type)
                ]));
            }
        }
        else if (peek().value == '-') {
            consume();
            if (peek().value == '-') {
                boda.push(...ab.ir);
                consume();
                boda.push(new IrInstruction('ChgSecRe', []));
                boda.push(...ab.ir);
                boda.push(new IrInstruction('Get',[ab.pointer ? 8 : getTypeSize(ab.type)]))
                boda.push(new IrInstruction('ChgTerRe', []));
                boda.push(new IrInstruction('LoadFlat',[1]));
                boda.push(new IrInstruction(`Sub`));
                boda.push(new IrInstruction(`Store`, [
                    ab.pointer ? 8 : getTypeSize(ab.type),
                    ab.pointer ? 8 : getTypeSize(ab.type)
                ]));
            }
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

        if (op === '<') {
            let jal = newLabel("setl");
            /** 
            li64 r0, 1
            jineg seta
            li64 r0, 0
            seta:
             */
            ada.push(new IrInstruction("LoadFlat",[1]))
            ada.push(new IrInstruction("JmpIfLess",[jal]))
            ada.push(new IrInstruction("LoadFlat",[0]))
            ada.push(new IrInstruction("Label",[jal]))

        }
        else if  (op === '>') {
            let jal = newLabel("setg");
            /** 
            li64 r0, 1
            jipos seta
            li64 r0, 0
            seta:
             */
            ada.push(new IrInstruction("LoadFlat",[1]))
            ada.push(new IrInstruction("JmpIfGreater",[jal]))
            ada.push(new IrInstruction("LoadFlat",[0]))
            ada.push(new IrInstruction("Label",[jal]))

        }

        return {
            ir:ada
        };
    }
    function parseWhile(){

        expect("while");
        expect("(");

        let start = newLabel("while");
        let end = newLabel("end");
        
        let condition = parseCondition();

        let preir = []

        expect(")");
        expect("{");

        let body=[];

        while(peek().value !== "}") {
            endname = end;
            body.push(...inCodeSpace());
        }

        expect("}");

        preir.push(new IrInstruction(
                "SaveRet",
                []
        ));

        return [
            ...preir,

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
            ),
            new IrInstruction(
                "RestoreEnd",
                []
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
        if (peek().value == "/") {
            let oldi = i;
            consume();
            if (peek().value == '*') {
                consume();
                let dis = false;
                if (peek().value === '!') {
                    dis = true;
                    consume()
                }
                let ca = consume().value;
                expect("*");
                expect("/");
                return [new IrInstruction(dis ? 'Disable' : 'Enable', [ca])]
            }
            else i = oldi;
        }
        if (isFunction()) {return [parseFunction()];}
        if (peek().value === 'extern') {
            consume();
            if (peek().value === 'struct') {
                let oldi = i;
                consume();
                let sname = consume().value;
                if (peek().value !== ';') {
                    i = oldi;
                }
                else { 
                    if (ctx && ctx instanceof CtxTempExp) {
                        structs[sname] = ctx.structs[sname];
                    }
                    expect(";");
                    return [];
                }
            }
            if (peek().value === 'struct') consume();
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
            let params = [];

            let castFunc1 = false;
            let field = null;
            if (peek().value == '(') {
                consume();
                expect("*");
                field = consume().value;
                expect(")");
                castFunc1 = true;
            }
            let pointer = false
            if (!field) {
                pointer = false;

                if (peek().value === "*") {
                    consume();
                    pointer = true;
                }

                field = consume().value;
            }
            else if (castFunc1) {
                expect("(");
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
            }

            expect(";");

            let fd = {
                name: field,
                type,
                pointer,
                function: castFunc1
            }

            if (castFunc1) {
                fd.params = params;
            }

            fields.push(fd);
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

    let a = parseProgram();
    if (ctx && ctx instanceof CtxTempExp) {
        for (let m of Object.getOwnPropertyNames(structs)) {
            ctx.structs[m] = structs[m];
        }
    }
    return a;
}
/** @param {IrInstruction[]} pparsed  */
export function codeGen(pparsed) {
    let secondary = 0;
    let enableds = {};
    function mainReg() {
        return `r${secondary}`
    }
    let xas = {
        1: 'byte',
        2: 'word',
        4: 'dword',
        8: 'qword'
    }
    function optimizeNumLoader(n) {
        if (n <= 0xFF) {
            return `mov`;
        }
        else if (n <= 0xFFFF) {
            return `li16`;
        }
        else if (n <= 0xFFFFFFFF) {
            return `li32`;
        }
        return 'li64';
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
            return `${('use32Addr' in enableds) ? 'li32' : 'laddr'} ${mainReg()}, ${String(p.ps[0])}`;
        }
        else if (p.getType() === 'Enable') {
            enableds[p.ps[0]] = 'xd';
            if (p.ps[0] === 'pic') return ".pic sss_unused"
        }
        else if (p.getType() === 'Disable') {
            delete enableds[p.ps[0]];
        }
        else if (p.getType() === 'Field') {
            if (p.ps[0] !== 0)
                return `add ${mainReg()}, ${mainReg()}, ${String(p.ps[0])}`;
            
            return "";
        }
        else if (p.getType() === 'Desreference') {
            return `deref ${mainReg()}`;
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
            if (typeof p.ps[0] === "number") {
                if (p.ps[0] <= 0xFF) {
                    return `mov ${mainReg()}, ${String(p.ps[0])}`;
                }
                else if (p.ps[0] <= 0xFFFF) {
                    return `li16 ${mainReg()}, ${String(p.ps[0])}`;
                }
                else if (p.ps[0] <= 0xFFFFFFFF) {
                    return `li32 ${mainReg()}, ${String(p.ps[0])}`;
                }
            }
            return `li64 ${mainReg()}, ${String(p.ps[0])}`;
        }
        else if (p.getType() === 'Get') {
            return `lalts${String(p.ps[0] * 8)} ${mainReg()}`
        }
        else if (p.getType() === 'Declare') {
            if (p.ps[4] !== null) {
                return `${p.ps[0]}: db ${([...(Buffer.from(p.ps[4])),0]).map(v => "0" + Number(v).toString(16) + "h").join(",")}`;
            }
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
        else if(p.getType()==="JmpIfLess"){
            return `jineg ${p.ps[0]}`;
        }
        else if(p.getType()==="JmpIfGreater"){
            return `jipos ${p.ps[0]}`;
        }
        else if(p.getType()==="AsmInsert") {
            return p.ps[0];
        }
        else if(p.getType()=='ExitFunction') {
            let out = [];
            out.push(`jmp ${p.ps[0]}`);
            return out.join("\n");
        }
        else if(p.getType()==="JumpFalse"){
            return `cmp r2, r2, 0 jifeq ${p.ps[0]}`;
        }
        else if(p.getType()==="SaveRet"){
            return `push lnk`;
        }
        else if(p.getType()==="RestoreEnd"){
            return `pop lnk`;
        }
        else if (p.getType() === 'Compare') {
            return `cmp r2, r0, r1`
        }
        else if (p.getType() === 'Inline') {
            return p.ps[0].replaceAll("$$m", mainReg())
        }
        else if (p.getType() === "Call") {

            let target = p.ps[0];
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

            for (let ins of target) {
                out.push((argn !== 0 ? `   ` : "") + genA(ins));
                argn++;

            }

            out.push(
                `${(argn !== 0 ? `   ` : "")}bl ${mainReg()}`
            );
            argn++;

            out.push(
                `   add sp, sp, ${args.length*8}`
            )
            argn++;

            return out.filter(x => x.trim() !== "").join("\n");
        }
        else if (p.getType() === "Function") {
            let fn = p.ps[0];

            let out = [];

            for (let ins of fn.preb) {
                out.push((ins.getType() !== 'Label' ? "   " : "") + genA(ins));
            }

            out.push(`${fn.name}:`);
            let v = ((fn.sas/8)-1)*8;
            if (!(v >= 0)) v = 0;
            out.push(`   enter ${v}`);
            out.push(`   ${optimizeNumLoader(fn.ses+8)} r4, ${fn.ses+8}`);
            out.push(`   sub sp, sp, r4`);

            for (let ins of fn.body) {
                out.push((ins.getType() !== 'Label' ? "   " : "") + genA(ins));
            }

            out.push(`${fn.name}__stdend:`)
            out.push(`   ${optimizeNumLoader(fn.ses+8)} r4, ${fn.ses+8}`);
            out.push(`   add sp, sp, r4`);
            out.push("   leave");
            out.push("   ret");

            return out.filter(x => x.trim() !== "").join("\n");
        }
        return '';
    }
    function genA(p) {
        return genB(p)// + "; "+ p.getType();
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