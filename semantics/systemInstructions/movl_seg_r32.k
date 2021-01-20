requires "x86-configuration.k"

module MOVL-SEG-R32
  imports X86-CONFIGURATION
  rule <k>
    execinstr (movl:Opcode R1:R32, R2:Sreg,  .Operands) => 
    setRegisterValue(
        zeroExtend(getRegisterValue(R1, RSMap), 32),
        R2) ...
    </k>
    <regstate> RSMap </regstate>
    requires in64Bits(RSMap)

endmodule

