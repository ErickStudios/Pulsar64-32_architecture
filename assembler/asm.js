export class Context {
  constructor() {
    this.symbols = new Map();
    this.equs = new Map();
    this.codelen = 0;
    this.orgIn = 0;
    this.result = [];
    this.in64 = false;
  }
}

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
export function toBigEndianBytes(n, x) {
  let bytes = [];
  while (n > 0) {
    bytes.push(n & 0xFF);
    n = n >> 8;
  }
  bytes.reverse();
  while (bytes.length < x) {
    bytes.unshift(0);
  }
  return bytes;
}
export function AssembleLineWithoutContext(line, ctx, len=null) {
  if (len == null) {
    len = ctx.codelen;
  }
  let tokens = tokenize(line);
  let i = 0;
  let result = [];
  function peek() {
    console.log(tokens[i]);
    return tokens[i];
  }
  function fmt7(a) {
    return a.toUpperCase();
  }
  function fmt8(a) {
    return fmt7(a.value);
  }
  function psfmt7() {
    return parseSize(fmt8(consume()));
  }
  function psfmt72(a) {
    return a.value !== undefined ? parseSize(fmt8(a)) : undefined;
  }
  function peek7() {
    return typeof peek().value === 'string' ? fmt7(peek().value) : false;
  }
  function consume() {
    let axa = peek(); i++;
    return axa;
  }
  function expect(value) {
    let t = consume();
    if (!t || t.value !== value) {
      throw new Error("Expected " + value);
    }
  }
  function parseSize(name) {
    switch (fmt7(name)) {
      case 'BYTE': return 1;
      case 'WORD': return 2;
      case 'DWORD': return 4;
    }
  }
  function parsePrimary() {
    if (peek().value === '[') {
      consume();
      let v1 = parsePrimary();
      if (peek7() === 'IN') {
        consume();
        let v2 = parsePrimary();
        let result = v2.value + (v1.value - ctx.orgIn);
        expect("]");
        return ({ type: 'inm', value: result });
      }
      else if (peek7() === 'SEGMENT') {
        consume();
        let v2 = parsePrimary();
        expect(':');
        let v3 = parsePrimary();
        let result = (v3.value - v2.value) + v1.value;
        expect("]");
        return ({ type: 'inm', value: result });
      }
      else if (peek7() === 'OUT') {
        consume();
        let v2 = parsePrimary();
        let result = (v1.value - v2.value) + ctx.orgIn;
        expect("]");
        return ({ type: 'inm', value: result });
      }
    }
    if (typeof peek().value === 'number') return ({ type: 'inm', value: consume().value });
    if (peek7() === 'SP') {
      consume();
      return ({ type: 'stack' });
    }
    let ident;
    if (peek().type === 'identifier') {
      ident = consume();
      if (fmt7(ident.value) === 'OUT') {
        return ({ type: 'symbol', value: 'cpu.registers.result' });
      }
      /*if (ident.fmt7(value) === 'DX') {
        return ({ type: 'symbol', value: 'cpu.registers.data' });
      } [[Obsolete]]*/
      if (fmt7(ident.value) === 'PX') {
        return ({ type: 'symbol', value: 'cpu.registers.ptr' });
      }
      if (fmt7(ident.value) === 'AX') {
        return ({ type: 'symbol', value: 'cpu.registers.ax' });
      }
      if (fmt7(ident.value) === 'BX') {
        return ({ type: 'symbol', value: 'cpu.registers.bx' });
      }
      if (fmt7(ident.value) === 'CX') {
        return ({ type: 'symbol', value: 'cpu.registers.cx' });
      }
      if (fmt7(ident.value) === 'DX') {
        return ({ type: 'symbol', value: 'cpu.registers.dx' });
      }
      if (fmt7(ident.value) === 'AH') {
        return ({ type: 'symbol', value: 'cpu.registers.ah' });
      }
      if (fmt7(ident.value) === 'AL') {
        return ({ type: 'symbol', value: 'cpu.registers.al' });
      }
      if (fmt7(ident.value) === 'BH') {
        return ({ type: 'symbol', value: 'cpu.registers.bh' });
      }
      if (fmt7(ident.value) === 'BL') {
        return ({ type: 'symbol', value: 'cpu.registers.bl' });
      }
      if (fmt7(ident.value) === 'SS') {
        return ({ type: 'symbol', value: 'cpu.registers.ss' });
      }
      if (ctx.symbols.has(ident.value)) {
        return ({ type: 'inm', value: ctx.symbols.get(ident.value) + ctx.orgIn });
      }
      if (ctx.equs.has(ident.value)) {
        return ({ type: 'inm', value: ctx.equs.get(ident.value) });
      }
      return ({ type: 'inm', value: 0 });
    }
    if (ctx.symbols.has(ident.value)) {
      return ({ type: 'inm', value: ctx.symbols.get(ident.value) + ctx.orgIn });
    }
    if (ctx.equs.has(ident.value)) {
      return ({ type: 'inm', value: ctx.equs.get(ident.value) });
    }
    return ({ type: 'inm', value: 0 });

  }
  function movBytea(sizeof) {
    result.push(4);
    result.push(8);
    result.push(sizeof, 0);
  }
  function parseSymbol(name) {
    if (name === 'cpu.registers.result') {return 0;}
    if (name === 'cpu.registers.data') {return 1;}
    if (name === 'cpu.registers.ptr') {return 2;}
    if (name === 'cpu.registers.ax') {return 3;}
    if (name === 'cpu.registers.bx') {return 4;}
    if (name === 'cpu.registers.cx') {return 5;}
    if (name === 'cpu.registers.dx') {return 6;}
    if (name === 'cpu.registers.ah') {return 7;}
    if (name === 'cpu.registers.al') {return 8;}
    if (name === 'cpu.registers.bh') {return 9;}
    if (name === 'cpu.registers.bl') {return 10;}
    if (name === 'cpu.registers.ss') {return 11;}

  }
  function operandParse(op) {
    if (fmt7(op) == "SP") return { type: 'stack', bind: 2 };
    if (fmt7(op) == "INM") return { type: 'inm', bind: 0 };
    if (fmt7(op) == "REG") return { type: 'reg', bind: 1 };

  }
  function parseJmpType(id, ignore_start=false) {
    if (!ignore_start) { 
      consume();
      result.push(7);
    }

    let sizeof = 4;
    if (peek7() === 'SHORT') {
      consume();
      sizeof = 2;
    }
    result.push(sizeof);

    let expr = parsePrimary();
    if (expr.type === 'inm') {
      result.push(0);
    }
    else if (expr.type == 'symbol') {
      result.push(1);
    }
    else if (expr.type == 'stack') {
      result.push(2);
    }
    result.push(id);
    if (expr.type === 'inm') {
      result.push(...toBigEndianBytes(expr.value, sizeof));
    }
    else if (expr.type == 'symbol') {
      result.push(parseSymbol(expr.value))
    }
  }
  function parseCmp(sizeof) {
    consume();
      result.push(6);
      result.push(sizeof);
      let operand1 = parsePrimary();
      expect(",");
      let operand2 = parsePrimary();

      result.push(((
        operand1.type == 'inm' ? 0 :
        operand1.type == 'symbol' ? 1 :
        operand1.type == 'stack' ? 2 : 0
      ) << 4) | (
        operand2.type == 'inm' ? 0 :
        operand2.type == 'symbol' ? 1 :
        operand2.type == 'stack' ? 2 : 0
      ));

      if (operand1.type === 'inm') {
        result.push(...toBigEndianBytes(operand1.value, sizeof));
      }
      else if (operand1.type == 'symbol') {
        result.push(parseSymbol(operand1.value))
      }

      if (operand2.type === 'inm') {
        result.push(...toBigEndianBytes(operand2.value, sizeof));
      }
      else if (operand2.type == 'symbol') {
        result.push(parseSymbol(operand2.value))
      }
  }
  function parseOperation(id) {
    consume();
    result.push(4);
    result.push(id);
    expect('-');
    let sizeof = parseSize(consume().value);
    result.push(sizeof);
    expect('-');
    let operand1 = operandParse(consume().value);
    expect('-');
    let operand2 = operandParse(consume().value);
    result.push((operand1.bind << 4) | operand2.bind);
    let casterA = (operand) => {
      if (operand.type !== 'stack') {
        let primary = parsePrimary();
        if (primary.type === 'symbol' && operand.type === 'reg') {
          result.push(parseSymbol(primary.value));
          return true;
        }
        if (primary.type === 'inm' && operand.type === 'inm') {
          result.push(...toBigEndianBytes(primary.value, sizeof));
          return true;
        }
      }
      return false;
    }
    let a0 = casterA(operand1);
    if (a0 && operand2.type !== 'stack') expect(',');
    let a1 = casterA(operand2);
  }
  function parseIdent(value) {
    if (typeof value === 'number') return value;
    else if (ctx.symbols.has(value)) return ctx.symbols.get(value);
    return 0;
  }
  function parseStos(sizeof) {
      consume();
      result.push(8);
      let expr = parsePrimary();
      if (expr.type === 'inm') {
        result.push(0, sizeof, ...toBigEndianBytes(expr.value, sizeof));
      }
      else if (expr.type == 'symbol') {
        result.push(1, sizeof, parseSymbol(expr.value))
      }
  }
  function parseLoadAddr(sizeof) {
      consume();
      let dir = parseIdent(parsePrimary().value);
      const hexCompleto = dir.toString(16).padStart(sizeof * 2, '0');
      const bytes = hexCompleto.match(/.{1,2}/g);
      const paresDeBytes = [];
      for (let i = 0; i < bytes.length; i += 2) {
          paresDeBytes.push(['0' + bytes[i] + 'h', '0' + bytes[i + 1] + 'h']);
      }
      let codeExpand = "";
      paresDeBytes.forEach(v => {
        codeExpand += `addinmb2 ${v[0]}, ${v[1]} `;
      })

      result.push(...AssembleLineWithoutContext(codeExpand, ctx, len));
  }
  while (i < tokens.length) {
    if (!ctx.in64 && peek7() === 'PUSH') {
      consume();
      result.push(3);
      let sizeof = 4;
      if (peek().value === '-') {
        expect('-');
        sizeof = parseSize(consume().value);
      } else {
        if (peek7() === 'SHORT') {
          consume();
          sizeof = 2;
        }
        else if (peek7() === 'NEAR') {
          consume();
          sizeof = 1;
        }
      }
      let expr = parsePrimary();
      if (expr.type === 'inm') {
        result.push(0, sizeof, ...toBigEndianBytes(expr.value, sizeof));
      }
      else if (expr.type == 'symbol') {
        result.push(1, sizeof, parseSymbol(expr.value))
      }
    }
    else if (peek7() === 'ORG32') { consume(); ctx.in64 = false;}
    else if (peek7() === 'ORG64') { consume(); ctx.in64 = true;}
    else if (!ctx.in64 && peek7() === 'DBGAC64') { consume(); result.push(0xB); }
    else if (ctx.in64 && peek7() === 'SLCINM') {
      consume(); 
      result.push(1, 0xFF, 1, parseIdent(parsePrimary().value));
    }
    else if (ctx.in64 && peek7() === 'LD64') {
      parseLoadAddr(8);
    }
    else if (ctx.in64 && peek7() === 'LD32') {
      parseLoadAddr(4);
    }
    else if (ctx.in64 && peek7() === 'LD16') {
      parseLoadAddr(2);
    }
    else if (ctx.in64 && peek7() === 'RSTINM') {
      consume(); 
      result.push(1, 0xFF, 0xFF, 1);
    }
    else if (ctx.in64 && peek7() === 'ADDINMB2') {
      consume(); 
      result.push(
        1, 0x12, 
        ([parseIdent(parsePrimary().value), expect(',')])[0], 
        parseIdent(parsePrimary().value)
      );
    }
    else if (ctx.in64 && peek7() === 'LINM') {
      consume(); 
      result.push(
        1, 0x40, 
        ([consume(), expect(',')])[0], 
        parseIdent(parsePrimary().value)
      );
    }
    else if (!ctx.in64 && peek7() === 'STOSB') parseStos(1);
    else if (!ctx.in64 && peek7() === 'STOSW') parseStos(2);
    else if (!ctx.in64 && peek7() === 'STOSD') parseStos(4);
    else if (!ctx.in64 && peek7() === 'OUT') {
      consume();
      expect('-');
      result.push(8);
      let sizeof = parseSize(consume().value);
      let expr = parsePrimary();
      if (expr.type === 'inm') {
        result.push(0, sizeof, ...toBigEndianBytes(expr.value, sizeof));
      }
      else if (expr.type == 'symbol') {
        result.push(1, sizeof, parseSymbol(expr.value))
      }
    }
    else if (!ctx.in64 && peek7() === 'INT') {
      consume();
      expect('-');
      result.push(9);
      let sizeof = parseSize(consume().value);
      let expr = parsePrimary();
      if (expr.type === 'inm') {
        result.push(0, sizeof, ...toBigEndianBytes(expr.value, sizeof));
      }
      else if (expr.type == 'symbol') {
        result.push(1, sizeof, parseSymbol(expr.value))
      }
      else if (expr.type == 'stack') {
        result.push(2, sizeof);
      }
    }
    else if (!ctx.in64 && peek7() === 'LEA') {
      consume();
      let sizeof = 4;
      result.push(1);
      if (peek().value == '-') {
      sizeof = parseSize(consume().value);
      }
      let expr = parsePrimary();
      if (expr.type === 'inm') {
        result.push(0, sizeof, ...toBigEndianBytes(expr.value, sizeof));
      }
      else if (expr.type == 'symbol') {
        result.push(1, sizeof, parseSymbol(expr.value))
      }
      else if (expr.type == 'stack') {
        result.push(2, sizeof);
      }
    }
    else if (!ctx.in64 && peek7() === 'MOV') {
      consume();
      if (peek().value == '-') {
        consume();
        result.push(4);
        result.push(8);
        let sizeof = parseSize(consume().value);
        result.push(sizeof, 0);
      }
      else if (peek().value === '[') {
        expect("[");
        let sizeof;
        let expr;
        let sizeof1 = parseSize(consume().value);
        let expr1 = parsePrimary();
        expect("]");
        expect(",");
        let sizeof2 = parseSize(consume().value);
        let expr2 = parsePrimary();

        result.push(1);
        sizeof = sizeof1;
        expr = expr1;
        if (expr.type === 'inm') { result.push(0, sizeof, ...toBigEndianBytes(expr.value, sizeof)); }
        else if (expr.type == 'symbol') { result.push(1, sizeof, parseSymbol(expr.value)) }
        else if (expr.type == 'stack') { result.push(2, sizeof); }

        result.push(8);
        sizeof = sizeof2;
        expr = expr2;
        if (expr.type === 'inm') { result.push(0, sizeof, ...toBigEndianBytes(expr.value, sizeof)); }
        else if (expr.type == 'symbol') { result.push(1, sizeof, parseSymbol(expr.value)) }
      }
      else {
        result.push(0xA);
        let sizeof = 4;
        if (peek7() === 'SHORT') {
          consume();
          sizeof = 2;
        }
        else if (peek7() === 'NEAR') {
          consume();
          sizeof = 1;
        }
        let reg = parsePrimary();
        if (reg.type === 'symbol') {
          let a = parseSymbol(reg.value);
          expect(",");
          let expr = parsePrimary();
          if (expr.type === 'inm') {
            result.push(0, sizeof, a, ...toBigEndianBytes(expr.value, sizeof));
          }
          else if (expr.type == 'symbol') {
            result.push(1, sizeof, a, parseSymbol(expr.value))
          }
          else if (expr.type == 'stack') {
            result.push(2, sizeof, a);
          }
        }
        }
    }
    else if (!ctx.in64 && peek7() === 'LODSB') [consume(), movBytea(1)];
    else if (!ctx.in64 && peek7() === 'LODSW') [consume(), movBytea(2)];
    else if (!ctx.in64 && peek7() === 'LODSD') [consume(), movBytea(4)];

    else if (!ctx.in64 && peek7() === 'HLT') {
      consume();
      result.push(5);
    }
    else if (!ctx.in64 && peek7() === "CMP") {
      consume();
      result.push(6);
      expect('-');
      let sizeof = parseSize(consume().value);
      result.push(sizeof);
      expect('-');
      let operand1 = operandParse(consume().value);
      expect('-');
      let operand2 = operandParse(consume().value);
      result.push((operand1.bind << 4) | operand2.bind);

      let casterA = (operand) => {
        if (operand.type !== 'stack') {
          let primary = parsePrimary();
          if (primary.type === 'symbol' && operand.type === 'reg') {
            result.push(parseSymbol(primary.value));
            return true;
          }
          if (primary.type === 'inm' && operand.type === 'inm') {
            result.push(...toBigEndianBytes(primary.value, sizeof));
            return true;
          }
        }
        return false;
      }
      let a0 = casterA(operand1);
       if (a0 && operand2.type !== 'stack') expect(',');
      let a1 = casterA(operand2);
    }
    else if (!ctx.in64 && peek7() === "CMPSB") parseCmp(1);
    else if (!ctx.in64 && peek7() === "CMPSW") parseCmp(2);
    else if (!ctx.in64 && peek7() === "CMPSD") parseCmp(4);
    else if (!ctx.in64 && peek7() === "JMP") {
      consume();
      result.push(7);
      if (peek().value !== '-') {
        parseJmpType(0, true);
      }
      else {
        expect('-');
        let sizeof = parseSize(consume().value);
        result.push(sizeof);
        expect('-');
        let mode = consume().value;
        let expr = parsePrimary();
        if (expr.type === 'inm') {
          result.push(0);
        }
        else if (expr.type == 'symbol') {
          result.push(1);
        }
        else if (expr.type == 'stack') {
          result.push(2);
        }
        if (fmt7(mode) === 'CLASIC') {
          result.push(0);
        }
        else if (fmt7(mode) === 'ZERO') {
          result.push(1);
        }
        else if (fmt7(mode) === 'LESS') {
          result.push(2);
        }
        else if (fmt7(mode) === 'GREATER') {
          result.push(3);
        }
        else if (fmt7(mode) === 'CALL') {
          result.push(4);
        }
        if (expr.type === 'inm') {
          result.push(...toBigEndianBytes(expr.value, sizeof));
        }
        else if (expr.type == 'symbol') {
          result.push(parseSymbol(expr.value))
        }
      }
    }
    else if (!ctx.in64 && peek7() === "JZ") parseJmpType(1);
    else if (!ctx.in64 && peek7() === "JL") parseJmpType(2);
    else if (!ctx.in64 && peek7() === "JG") parseJmpType(3);
    else if (!ctx.in64 && peek7() === "CALL") parseJmpType(4);
    else if (!ctx.in64 && peek7() === 'ADD') parseOperation(1);
    else if (!ctx.in64 && peek7() === 'SUB') parseOperation(2);
    else if (!ctx.in64 && peek7() === 'MUL') parseOperation(3);
    else if (!ctx.in64 && peek7() === 'DIV') parseOperation(4);
    else if (!ctx.in64 && peek7() === 'AND') parseOperation(5);
    else if (!ctx.in64 && peek7() === 'OR') parseOperation(6);
    else if (!ctx.in64 && peek7() === 'XOR') parseOperation(7);
    else if (!ctx.in64 && peek7() === 'SHL') parseOperation(9);
    else if (!ctx.in64 && peek7() === 'SHR') parseOperation(10);
    else if (!ctx.in64 && peek7() === 'MOD') parseOperation(0xF);
    else if (!ctx.in64 && peek7() === 'ASSUME') {
      consume();
      expect('-');
      let action = consume();
      if (fmt7(action.value) === 'ORG') {
        let inWhere = consume();
        ctx.orgIn = inWhere.value;
      }
      else if (parseSize(fmt8(action)) !== undefined) {
        let sizeof = psfmt72(action.value);
        let primarys = toBigEndianBytes(parseIdent(parsePrimary().value),sizeof);
        while (peek() && peek().value === ",") {
          consume();
          primarys.push(...toBigEndianBytes(
            parseIdent(parsePrimary().value),sizeof
          ));
        }
        result.push(...primarys);
      }
      else if (fmt8(action) === "FILL") {
        let fillto = consume().value;
        let bytesfill = fillto - len;
        result.push(...Array(bytesfill).fill(0));
      }
    }
    else if (peek7() === 'ALIGN') {
      consume();
      let primarys = parseIdent(parsePrimary().value);
      let alignTo = primarys;
      let bytesfill = (alignTo - (len % alignTo)) % alignTo;
      result.push(...Array(bytesfill).fill(0));
    }
    else if (!ctx.in64 && peek7() === 'ROR') {
      consume();
      result.push(0xA);
      expect('-');
      let sizeof = parseSize(consume().value);
      let reg = parsePrimary();
      if (reg.type === 'symbol') {
        let a = parseSymbol(reg.value);
        expect(",");
        let expr = parsePrimary();
        if (expr.type === 'inm') {
          result.push(0, sizeof, a, ...toBigEndianBytes(expr.value, sizeof));
        }
        else if (expr.type == 'symbol') {
          result.push(1, sizeof, a, parseSymbol(expr.value))
        }
        else if (expr.type == 'stack') {
          result.push(2, sizeof, a);
        }
      }
    }
    else if (parseSize(fmt8(peek())) !== undefined) {
      let sizeof = psfmt7();
      let primarys = toBigEndianBytes(parseIdent(parsePrimary().value), sizeof);
      while (peek() && peek().value === ",") {
        consume();
        primarys.push(...toBigEndianBytes(
          parseIdent(parsePrimary().value), sizeof
        ));
      }
      result.push(...primarys);
    }
    else if (peek().type === 'symbol' && peek().value === ';') break;
    else if (peek().type === 'identifier' && typeof peek().value === 'string') {
      let varName = consume().value;
      if (peek().type === 'symbol' && peek().value === ':') {
        consume();
        if (!('passDefedNot' in ctx)) ctx.symbols.set(varName, ctx.codelen);
        continue;
      } else if (peek7() === 'EQU') {
        consume();
        let v = consume().value;
        if (!('passDefedNot' in ctx)) ctx.equs.set(varName, v);
        continue;
      }else {
        throw new Error("Unexpected identifier: " + varName);
      }
    }
  }
  return result;
}
export function AssembleCode(code) {
  let lines = code.split('\n');
  let result = [];
  let context = new Context();
  lines.forEach((line, i) => {
    let lineAssembled = AssembleLineWithoutContext(line, context);
    context.codelen += lineAssembled.length;
  })
  context.passDefedNot = true;
  let len = 0;
  lines.forEach((line,i) => {
    let lineAssembled = AssembleLineWithoutContext(line, context,len);
    result.push(...lineAssembled);
    len += lineAssembled.length;
  })
  return { result, context };
}