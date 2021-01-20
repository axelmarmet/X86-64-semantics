requires "x86-configuration.k"

module MOVL-RCONT-R32
  imports X86-CONFIGURATION
  rule <k>
    execinstr (movl:Opcode R1:R32, R2:ControlRegister,  .Operands) => 
    setControlRegisterValue(getRegisterValue(R1, RSMap), R2) ...
    </k>
    <regstate> RSMap </regstate>
    requires in32Bits(RSMap) andBool getCPL(RSMap) ==Int 0

    rule <k>
      execinstr (movq:Opcode R1:R64, R2:ControlRegister,  .Operands) => 
      execinstr (movl convertR64ToR32(R1), R2,  .Operands) ...
    </k>
    <regstate> RSMap </regstate>
    requires in32Bits(RSMap)

endmodule

