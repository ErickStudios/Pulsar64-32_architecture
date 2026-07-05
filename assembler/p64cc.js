class BaseTypeConstructor {
    constructor() { }
    construct() { throw new TypeError("the base type has not constructor") }
    calculeSize() { return 0; }
}
class BaseTypeInstance {
    constructor(typeClassName) { this.cls = typeClassName; }
}
class ArrayTypeConstructor
extends BaseTypeConstructor {
    constructor(typeBase, elementsCount) {
        super();
        if (!(typeBase instanceof BaseTypeConstructor)) 
            throw new TypeError('Invalid type base for array');
        if (typeof elementsCount !== 'number')
            throw new TypeError('Invalid length for array');

        this.typeBase = typeBase;
        this.elementsCount = elementsCount;
    }
    calculeSize() {
        return this.typeBase.calculeSize() * this.elementsCount;
    }
    construct() {
        return new ArrayTypeInstance(this);
    }
}
class NativeType 
extends BaseTypeConstructor {
    constructor(sizeof) {
        super();
        this.size = sizeof;
    }
    calculeSize() {
        return this.size;
    }
    construct() {
        return new NativeTypeInstance(this);
    }
};
class StructureType 
extends BaseTypeConstructor {
    constructor() {
        super();
        /** @type { {name:string, field:BaseTypeConstructor}[] } */
        this.fields = [];
    }
    appendField(name, field) {
        if (!(field instanceof BaseTypeConstructor))
            throw new Error("Unrreconocible type base");
        
        this.fields.push({name, field});
    }
    calculeSize() {
        let size = 0;
        this.fields.forEach(v => {
            size += v.field.calculeSize();
        });
        return size;
    }
    construct() {
        return new StructuredTypeInstance(this);
    }
};
class ArrayTypeInstance
extends BaseTypeInstance {
    constructor(aParent) {
        if (!(aParent instanceof ArrayTypeConstructor)) 
            throw new TypeError("Invalid constructor for a array");

        super('array');

        this.elementsCount = aParent.elementsCount;
        this.typeBase = aParent.typeBase;
    }
};
class StructuredTypeInstance 
extends BaseTypeInstance {
    constructor(sParent) {
        if (!(sParent instanceof StructureType)) 
            throw new TypeError("Invalid constructor for a struct");

        super('structured');

        this.size = sParent.calculeSize();
        /** @type {{name: string, field: BaseTypeInstance}[]} */
        this.fields = [];

        for (/** @type {{name: string, field: BaseTypeConstructor;}}*/const field of sParent.fields) {
            this.fields.push({name: field.name, field: field.field.construct()});
        }
    }
};
class NativeTypeInstance 
extends BaseTypeInstance {
    constructor(tParent) {
        if (!(tParent instanceof NativeType)) 
            throw new TypeError();

        super('native');
        this.size = tParent.calculeSize();
    }
};

function tokenize(code) {
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
    tokens.push({ type: "symbol", value: c });
    i++;
  }
  return tokens;
}
/** @param {{type: string;value: number | string;}[]} tokens  */
function parse(tokens) {
    let i = 0;

    let typesBuiltin = {
        'char': new NativeType(1),
        'short': new NativeType(2),
        'int': new NativeType(4),
        'long': new NativeType(8)
    };

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

    /** @returns { BaseTypeConstructor } */
    function valideType(name, launchEx=true) {
        if (name in typesBuiltin) {
            let typa = typesBuiltin[name];
            if (!(typa instanceof BaseTypeConstructor)) {
                throw new TypeError("Invalid type constructor");
            }
            return typesBuiltin[name];
        }

        if (launchEx) throw new TypeError("Unknown type");
        return null;
    }

    function parseVarDecl() {
        let abc = consume().value;
        let typea = valideType(abc, false);
        if (typea === null) {
            return parseIdentifier(abc);
        }
        else {
            let name = consume().value;
            if (peek().value === '(') {
                consume();
                expect(')');
                expect('{');
                let body = [];
                while (peek() && peek().value != '}') {
                    let adda = parseStatment();

                    if (adda) body.push(adda);
                }
                expect("}");
                return { type: 'FunctionDecl', name: name, body }
            }
            else {

            let heIsHaveToBeAArray = false;
            let ArrayElementsList = 0;

            if (peek().value === '[') {
                consume();
                heIsHaveToBeAArray = true;
                ArrayElementsList = consume().value;
                typea = new ArrayTypeConstructor(typea, ArrayElementsList);
                expect("]");
            }

            expect(';');

            let instanced = typea.construct();

            return {type: 'InstanceVariable', name, instanced}; }
        }
    }

    function parseStructDefinition() {
        consume();
        let name = "_unnamed";

        if (peek().value !== "{")
            name = consume().value;

        expect("{");

        let st = new StructureType();

        while (peek().value !== "}") {

            let typeName = consume().value;
            let fieldName = consume().value;
            let arrayItem = null;

            if (peek().value == '[') {
                consume();
                arrayItem = consume().value;
                expect(']');
            }

            let tata;
            
            if (arrayItem !== null) {
                tata = new ArrayTypeConstructor(valideType(typeName), arrayItem);
            } else tata = valideType(typeName);

            st.appendField(
                fieldName,
                tata
            );

            expect(";");
        }

        expect("}");
        expect(";");

        typesBuiltin[name] = st;

        return {type: 'StructureDefinition', st};
    }

    function parseFieldEnter(main) {
        let fields = [];
        while (peek() && peek().value === '.') {
            consume();
            let field = consume().value;
            if (peek().value == '[') {
                consume();
                let arrite = parseSyntaxDot();
                if (arrite.type === 'InmediateGet') {
                    fields.push(field + "_item" + arrite.value);
                }
                else if (arrite.type === 'NonInmediateGet') {
                    fields.push({type: 'FromIndirect', field, varuse: arrite.addr});
                }
                expect("]");
            }
            else fields.push(field);
        }
        return {type: 'FieldAccess', obj: main, fields};
    }

    function parseIdentifier(identa) {
        if (peek().value === '.') {
            return parseFieldEnter(identa);
        }

        return {type: 'VariableUse', name: identa};
    }

    function parseSyntaxDot() {
        let abc = consume().value;
        if (typeof abc !== 'number') {
            return { type: 'NonInmediateGet', addr: parseIdentifier(abc) };
        } else {
            return { type: 'InmediateGet', value: abc };
        }
    }

    function parseSentence() {
        let ene = parseVarDecl();

        // empezara la cosa seria
        if (ene.type === 'VariableUse' || ene.type === 'FieldAccess') {
            // asignacion
            if (peek().value === '=') {
                consume();
                let b = parseSyntaxDot();
                expect(";");
                return { type: 'Assignation', dest: ene, src: b };
            }
        }

        return ene;
    }

    let body = [];

    function parseStatment() {
        let token = typeof peek().value === 'string' ? 
                    peek().value : 
                    (() => {
                        throw new TypeError("invalid keyword");
                    })();
        if (token === 'struct') return parseStructDefinition();
        else { 
            return parseSentence();
        }
    }

    while (i < tokens.length) {
        let adda = parseStatment();

        if (adda) body.push(adda);
    }

    return body;
}
function codeGen(parsed) {
    let mappedSizes = {
        1: 'byte',
        2: 'word',
        4: 'dword',
        8: 'qword'
    }
    let dictSymbols = {};
    function genNativeType(t) {
        if (t instanceof NativeTypeInstance) {
            return ' ' + mappedSizes[t.size] + ' 0' + "\n";
        }

        throw new TypeError("Invalid type");
    }
    function genStructure(t, name) {
        if (t instanceof StructuredTypeInstance) {
            let codega = name + ': ; structured instance\n';
            t.fields.forEach(v => {
                codega += genAuto(v.field, name + '_' + v.name);
            })

            return codega;
        }

        throw new TypeError("Invalid type");
    }
    function genAuto(t, name) {
        if (t instanceof ArrayTypeInstance) {
            return genArray(t, name);
        }
        if (t instanceof StructuredTypeInstance) {
            return genStructure(t, name);
        }
        if (t instanceof NativeTypeInstance) {
            dictSymbols[name] = t.size * 8;
            return name + ":" + genNativeType(t);
        }

        return "";
    }
    function genArray(t, name) {
        if (t instanceof ArrayTypeInstance) {
            let codega = name + ': ; array instance ' + t.elementsCount + ' items\n';
            for (let index = 0; index < t.elementsCount; index++) {
                codega += genAuto((t.typeBase.construct()), name + "_item" + String(index));
            }

            return codega;
        }

        throw new TypeError("Invalid type");
    }

    function registerRecallSyntaxPrev(sint, offSize, calca) {
        if (sint.type === 'FieldAccess' || sint.type === 'VariableUse') {
            let ana = serializeAccessPoint(sint);
            return `   ; access direction index
   li64 r0, ${ana}
   ifm${dictSymbols[ana]} 04h, r0
   linm r0, 04h
   li64 r5, ${calca}
   ; calculate absolute direction with offset
   mul r0, r0, ${offSize}
   add r0, r5, r0
`;
        } else {
            return `   li64 r0, ${calca}_item${sint.value}`;
        }
    }

    function serializeAccessPoint(ina) {
        if (ina.type === 'FieldAccess') {
            let coda = ina.obj + "_";
            for (let index = 0; index < ina.fields.length; index++) {
                const element = ina.fields[index];
                console.log(element);
                coda += typeof element === 'string' ? element : element.field;
                if (index < (ina.fields.lengt - 1)) {
                    coda += "_"
                }
            }
            return coda;
        }

        return ina.name;
    }

    function hasIndirectAccess(fieldAccess) {
        return fieldAccess.fields.some(f =>
            typeof f !== "string" &&
            f.type === "FromIndirect"
        );
    }

    function parseAGroup(list) {
        let codega = "";
        list.forEach(v => {
            if (v.type === 'InstanceVariable') {
                codega += genAuto(v.instanced, v.name);
            }
            else if (v.type === 'FunctionDecl') {
                codega += v.name + ":\n" + parseAGroup(v.body);
            }
            else if (v.type === 'Assignation') {
                let destName = serializeAccessPoint(v.dest);
                let source   = v.src;

                if (source.type === 'InmediateGet') {
                    codega += `   ; get inm from code raw\n   li64 r1, ${source.value}\n`;
                }
                else if (source.type === 'NonInmediateGet') {
                    let srcName = serializeAccessPoint(source.addr);
                    codega += `   ; get variable value\n   li64 r0, ${srcName}\n   ifm${dictSymbols[srcName]} 04h, r0\n   linm r1, 04h\n`;
                }

if (v.dest.type === "FieldAccess" && hasIndirectAccess(v.dest)) {

    let indirect = v.dest.fields.find(f =>
        typeof f !== "string"
    );

    codega += registerRecallSyntaxPrev(
        indirect.varuse, // i
        1,               // sizeof(char)
        "b_name"         // base del array
    );

    codega += "   ; write variable\n   mwr8 r0, r1\n";
}
else {
    let destName = serializeAccessPoint(v.dest);

    codega += `   ; write variable
   li64 r0, ${destName}
   mwr${dictSymbols[destName]} r0, r1
`;
}
            }
            else { 
                serializeAccessPoint(v); 
            }

        });

        return codega;
    };

    return parseAGroup(parsed);
}
let xd = tokenize(`
struct tableElement {
    long identifier;
    long index;
    char name[12];
};
tableElement b;
int i;
int _start() {
    i = 10;
    b.name[i] = b.name[1];
}
`);
//console.log(xd)

let a = parse(xd);

/**
b:
b_xd:
b_xd_identifier:
    qword 0
b_xd_index:
    qword 0


 */

console.log(codeGen(a));