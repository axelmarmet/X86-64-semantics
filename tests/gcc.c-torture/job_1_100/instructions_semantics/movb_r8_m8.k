// Autogenerated using stratification.
requires "x86-configuration.k"

module MOVB-R8-M8
  imports X86-CONFIGURATION

  context execinstr(movb:Opcode HOLE:Mem, R2:R8,  .Operands) [result(MemOffset)]
  
  rule <k>
    execinstr (movb:Opcode memOffset( MemOff:MInt):MemOffset, R2:R8,  .Operands) =>
      loadFromMemory( MemOff, 8) ~>
      execinstr (movb memOffset( MemOff), R2,  .Operands)
  ...</k>
    <regstate> RSMap:Map </regstate>
          
  rule <k>
    memLoadValue(Mem8:MInt):MemLoadValue ~> execinstr (movb:Opcode memOffset( MemOff:MInt):MemOffset, R2:R8,  .Operands) =>
      .
  ...</k>
    <regstate>
      RSMap:Map => updateMap(RSMap,
convToRegKeys(R2) |-> concatenateMInt( extractMInt( getParentValue(R2, RSMap), 0, 56), Mem8)
      )
    </regstate>
endmodule
