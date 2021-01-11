requires "x86-configuration.k"


module LGDTL
  imports X86-CONFIGURATION

  context execinstr(lgdtl:Opcode HOLE:Mem, .Operands) [result(MemOffset)]

  rule <k> 
    execinstr (lgdtl memOffset(Addr:MInt):MemOffset, .Operands) => 
    setRegisterValue(loadWord(Addr), %gdtr_limit) ~>
    setRegisterValue(loadQuadWord(addMInt(Addr, mi(64, 2))), %gdtr_base) ...
  </k>
  <processormode> b64 </processormode>

endmodule
