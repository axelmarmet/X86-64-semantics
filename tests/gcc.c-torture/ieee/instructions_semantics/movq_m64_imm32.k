// Autogenerated using stratification.
requires "x86-configuration.k"

module MOVQ-M64-IMM32
  imports X86-CONFIGURATION

  context execinstr(movq:Opcode Imm32:Imm, HOLE:Mem,  .Operands) [result(MemOffset)]
  
  rule <k>
     execinstr (movq:Opcode Imm32:Imm, memOffset( MemOff:MInt):MemOffset,  .Operands) =>
      
            storeToMemory(
              mi(64, svalueMInt(handleImmediateWithSignExtend(Imm32, 32, 32))),
              MemOff,
              64
            )
          
  ...</k>
    <regstate> RSMap:Map </regstate>
endmodule
