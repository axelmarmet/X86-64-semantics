requires "x86-configuration.k"


module JB-DISLABEL
  imports X86-CONFIGURATION
  imports X86-FLAG-CHECS-SYNTAX

  rule <k> 
    execinstr (jb Dis:DisAddress, .Operands) => .
  ...</k>
      <regstate> RSMap => updateMap(RSMap, ("RIP" |-> getAddress(Dis)))
      </regstate>
        requires  eqMInt({RSMap["CF"]}:>MInt, mi(1, 1))

  rule <k> 
    execinstr (jb Dis:DisAddress, .Operands) => .
  ...</k>
      <regstate> RSMap:Map </regstate> 
        requires  eqMInt({RSMap["CF"]}:>MInt, mi(1, 0))
endmodule
