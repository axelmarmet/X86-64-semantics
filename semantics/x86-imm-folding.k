requires "x86-configuration.k"

module X86-IMM-FOLDING-SYNTAX

  imports X86-SORT

  syntax Imm ::= fold(ImmToFold) [strict]
  syntax Imm ::= "placeholder"

endmodule

module X86-IMM-FOLDING

  imports DOMAINS
  imports X86-CONFIGURATION
  imports X86-IMM-FOLDING-SYNTAX

  rule ~ I1 => ~Int I1 
  rule I1 >> I2 => I1 >>Int I2 
  rule I1 << I2 => I1 <<Int I2 
  rule I1 |  I2 => I1 |Int I2 
  rule I1 &  I2 => I1 &Int I2 

  rule <k> execinstr (OpC:Opcode I1:ImmToFold, O2, .Operands) => fold(I1) ~> execinstr(OpC placeholder, O2, .Operands) ... </k>
  rule <k> fold(I:Int) ~> execinstr (OpC:Opcode placeholder, O2, .Operands) => execinstr (OpC:Opcode ($ I), O2, .Operands) ... </k>


endmodule