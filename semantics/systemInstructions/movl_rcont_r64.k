requires "x86-configuration.k"

module MOVL-RCONT-R64
  imports X86-CONFIGURATION
  rule <k>
    execinstr (movq:Opcode R1:R64, R2:ControlRegister,  .Operands) => 
    setControlRegisterValue(extractMask(getRegisterValue(R1, RSMap), 32, 0), R2) ...
    </k>
    <regstate> RSMap </regstate>
    requires in64Bits(RSMap) andBool getCPL(RSMap) ==Int 0

    rule <k>
      execinstr (movl:Opcode R1:R32, R2:ControlRegister,  .Operands) => 
      execinstr (movq convSubRegsToRegs(R1), R2,  .Operands) ...
    </k>
    <regstate> RSMap </regstate>
    requires in64Bits(RSMap)

endmodule

