// Autogenerated using stratification.
requires "x86-configuration.k"

module XCHGB-M8-R8
  imports X86-CONFIGURATION

  context execinstr(xchgb:Opcode R1:R8, HOLE:Mem,  .Operands) [result(MemOffset)]
  
  rule <k>
    execinstr (xchgb:Opcode R1:R8, memOffset( MemOff:MInt):MemOffset,  .Operands) =>
      loadFromMemory( MemOff, 8) ~>
      execinstr (xchgb R1, memOffset( MemOff),  .Operands)
  ...</k>
    <regstate> RSMap:Map </regstate>
          
  rule <k>
    memLoadValue(Mem8:MInt):MemLoadValue ~> execinstr (xchgb:Opcode R1:R8, memOffset( MemOff:MInt):MemOffset,  .Operands) =>
      
            storeToMemory(
              extractMInt( getParentValue(R1, RSMap), 56, 64),
              MemOff,
              8
            )
          
  ...</k>
    <regstate>
      RSMap:Map => updateMap(RSMap,
convToRegKeys(R1) |-> concatenateMInt( extractMInt( getParentValue(R1, RSMap), 0, 56), Mem8)
      )
    </regstate>
endmodule
