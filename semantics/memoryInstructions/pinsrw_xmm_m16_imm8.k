// Autogenerated using stratification.
requires "x86-configuration.k"

module PINSRW-XMM-M16-IMM8
  imports X86-CONFIGURATION

  context execinstr(pinsrw:Opcode Imm8:Imm, HOLE:Mem, R3:Xmm,  .Operands) [result(MemOffset)]
  
  rule <k>
    execinstr (pinsrw:Opcode Imm8:Imm, memOffset( MemOff:MInt):MemOffset, R3:Xmm,  .Operands) =>
      loadFromMemory( MemOff, 16) ~>
      execinstr (pinsrw Imm8, memOffset( MemOff), R3:Xmm,  .Operands)
  ...</k>
    <regstate> RSMap:Map </regstate>
          
  rule <k>
    memLoadValue(Mem16:MInt):MemLoadValue ~> execinstr (pinsrw:Opcode Imm8:Imm, memOffset( MemOff:MInt):MemOffset, R3:Xmm,  .Operands) =>
      .
  ...</k>
    <regstate>
      RSMap:Map => updateMap(RSMap,
convToRegKeys(R3) |-> concatenateMInt( extractMInt( getParentValue(R3, RSMap), 0, 128), orMInt( andMInt( extractMInt( getParentValue(R3, RSMap), 128, 256), negMInt( shiftLeftMInt( mi(128, 65535), uvalueMInt(shiftLeftMInt( concatenateMInt( mi(125, 0), extractMInt( handleImmediateWithSignExtend(Imm8, 8, 8), 5, 8)), uvalueMInt(mi(128, 4))))))), andMInt( shiftLeftMInt( concatenateMInt( mi(112, 0), Mem16), uvalueMInt(shiftLeftMInt( concatenateMInt( mi(125, 0), extractMInt( handleImmediateWithSignExtend(Imm8, 8, 8), 5, 8)), uvalueMInt(mi(128, 4))))), shiftLeftMInt( mi(128, 65535), uvalueMInt(shiftLeftMInt( concatenateMInt( mi(125, 0), extractMInt( handleImmediateWithSignExtend(Imm8, 8, 8), 5, 8)), uvalueMInt(mi(128, 4))))))))
      )
    </regstate>
endmodule
