requires "x86-configuration.k"


module LJMPL
  imports X86-CONFIGURATION
  imports X86-COMMON-ERROR

  rule 
    <k> 
      execinstr (ljmpl SegOff:Imm, PCOff:Imm, .Operands) => 
        setRegisterValue(
          loadQuadWord(addMInt(
            getRegisterValue(%gdtr_base, RSMap),
            handleImmediate(SegOff, 64)
          )),
          %cs
        ) ~>
        execinstr (ljmpl PCOff:Imm, .Operands) ...
    </k>
  <regstate> RSMap </regstate>
  //requires immToInt(SegOff) <=Int  uvalueMInt(getRegisterValue(GDTR_BASE, RSMap))

  // rule 
  //   <k> 
  //     execinstr (ljmpl SegOff:Imm, PCOff:Imm, .Operands) => 
  //     error(outOfBoundsMemoryAccess) ...
  //   </k>
  // <regstate> RSMap </regstate>
  // requires immToInt(SegOff) >Int  uvalueMInt(getRegisterValue(GDTR_LIMIT, RSMap))
  
  rule 
    <k>
      execinstr (ljmpl PCOff:Imm, .Operands) => . ... 
    </k>
    <regstate> RSMap => updateMap(RSMap, ("RIP" |-> handleImmediate(PCOff, 64))) </regstate>

endmodule
