requires "x86-configuration.k"

module MOVL-R64-RCONT
  imports X86-CONFIGURATION
  rule <k>
    execinstr (movq:Opcode R1:ControlRegister, R2:R64,  .Operands) => 
    setRegisterValue(zeroExtend(getControlRegisterValue(R1, RSMap), 64), R2) ...
    </k>
    <regstate> RSMap </regstate>
    requires in64Bits(RSMap) andBool getCPL(RSMap) ==Int 0

  rule <k>
    execinstr (movl:Opcode R1:ControlRegister, R2:R32,  .Operands) => 
    execinstr (movq R1, convSubRegsToRegs(R2),  .Operands)  ...
    </k>
   <regstate> RSMap </regstate>
    requires in64Bits(RSMap)


endmodule

