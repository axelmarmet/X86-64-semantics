requires "x86-configuration.k"


module JNE-DISLABEL
  imports X86-CONFIGURATION
  imports X86-FLAG-CHECS-SYNTAX

  rule <k> 
    execinstr (jne Dis:DisAddress, .Operands) => .
  ...</k>
      <regstate> RSMap => updateMap(RSMap, ("RIP" |-> getAddress(Dis)))
      </regstate>
        requires eqMInt({RSMap["ZF"]}:>MInt, mi(1, 0))

  rule <k> 
    execinstr (jne Dis:DisAddress, .Operands) => .
  ...</k>
      <regstate> RSMap:Map </regstate> 
        requires notBool eqMInt({RSMap["ZF"]}:>MInt, mi(1, 0))
endmodule
