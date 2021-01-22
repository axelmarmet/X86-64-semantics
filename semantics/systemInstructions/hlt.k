requires "x86-configuration.k"


module HLT
  imports X86-CONFIGURATION

  syntax KItem ::= "halted"

  rule 
    <k> 
    execinstr ( hlt:Opcode .Operands ) ~> inforegisters ~> fetch =>
    halted
    </k>

endmodule
