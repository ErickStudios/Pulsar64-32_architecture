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

    class BaseTypeConstructor {
        constructor() { }
        construct() { throw new TypeError("the base type has not constructor") }
        calculeSize() { return 0; }
    }

    class BaseTypeInstance {
        constructor(typeClassName) { this.cls = typeClassName; }
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

    class StructuredTypeInstance 
    extends BaseTypeInstance {
        constructor(sParent) {
            if (!(sParent instanceof StructureType)) 
                throw new TypeError();

            super('structured');

            this.size = sParent.calculeSize();
            this.fields = {};

            for (const field of sParent.fields) {
                this.fields[field.name] = field.field.construct();
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
    function valideType(name) {
        if (name in typesBuiltin) {
            let typa = typesBuiltin[name];
            if (!(typa instanceof BaseTypeConstructor)) {
                throw new TypeError("Invalid type constructor");
            }
            return typesBuiltin[name];
        }

        throw new TypeError("Unknown type");
    }

    function parseVarDecl() {
        let abc = consume().value;
        let typea = valideType(abc);
        let name = consume().value;

        expect(';');

        let instanced = typea.construct();

        return {type: 'InstanceVariable', name, instanced};
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

            st.appendField(
                fieldName,
                valideType(typeName)
            );

            expect(";");
        }

        expect("}");
        expect(";");

        typesBuiltin[name] = st;

        return {type: 'StructureDefinition', st};
    }

    let body = [];

  while (i < tokens.length) {
    let token = typeof peek().value === 'string' ? 
                peek().value : 
                (() => {
                    throw new TypeError("invalid keyword");
                })();
    let adda;
    if (token === 'struct') adda = parseStructDefinition();
    else adda = parseVarDecl();

    body.push(adda);
  }

  return body;
}
console.log(parse(tokenize(`
struct MyStruct {
    char x;
};
MyStruct b;
`)));