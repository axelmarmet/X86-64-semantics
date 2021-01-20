requires "x86-configuration.k"

module MOVL-R32-RCONT
  imports X86-CONFIGURATION
  rule <k>
    execinstr (movl:Opcode R1:ControlRegister, R2:R32,  .Operands) => 
    setRegisterValue(extractMask(getControlRegisterValue(R1, RSMap), 32, 0), R2) ...
    </k>
    <regstate> RSMap </regstate>
    requires in32Bits(RSMap) andBool getCPL(RSMap) ==Int 0

  rule <k>
    execinstr (movq:Opcode R1:ControlRegister, R2:R64,  .Operands) => 
    execinstr (movl R1, convertR64ToR32(R2),  .Operands)  ...
    </k>
   <regstate> RSMap </regstate>
    requires in32Bits(RSMap)


endmodule

