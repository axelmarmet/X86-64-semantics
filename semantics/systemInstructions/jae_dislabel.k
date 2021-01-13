requires "x86-configuration.k"


module JAE-DISLABEL
  imports X86-CONFIGURATION
  imports X86-FLAG-CHECS-SYNTAX

  rule <k> 
    execinstr (jae  Dis:DisAddress, .Operands) => .
  ...</k>
      <regstate> RSMap => updateMap(RSMap, ("RIP" |-> getAddress(Dis)))
      </regstate>
        requires  eqMInt({RSMap["CF"]}:>MInt, mi(1, 0))

  rule <k> 
    execinstr (jae  Dis:DisAddress, .Operands) => .
  ...</k>
      <regstate> RSMap:Map </regstate> 
        requires  eqMInt({RSMap["CF"]}:>MInt, mi(1, 1))
endmodule
