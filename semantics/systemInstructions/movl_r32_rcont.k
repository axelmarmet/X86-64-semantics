requires "x86-configuration.k"

module MOVL-R32-RCONT
  imports X86-CONFIGURATION
  rule <k>
    execinstr (movl:Opcode R1:ControlRegister, R2:R32,  .Operands) => 
    setRegisterValue(getControlRegisterValue(R1, RSMap), R2) ...
    </k>
    <regstate> RSMap </regstate>
    <processormode> b32 </processormode>
    requires getCPL(RSMap) ==Int 0

  rule <k>
    execinstr (movq:Opcode R1:ControlRegister, R2:R64,  .Operands) => 
    execinstr (movl R1, convertR64ToR32(R2),  .Operands)  ...
    </k>
    <processormode> b32 </processormode>


endmodule

