// Autogenerated using stratification.
requires "x86-configuration.k"

module SETP-RH
  imports X86-CONFIGURATION

  rule <k>
    execinstr (setp R1:Rh,  .Operands) => .
  ...</k>
    <regstate>
RSMap:Map => updateMap(RSMap,
convToRegKeys(R1) |-> concatenateMInt( concatenateMInt( extractMInt( getParentValue(R1, RSMap), 0, 48), (#ifMInt eqMInt(getFlag("PF", RSMap), mi(1,1)) #then mi(8, 1) #else mi(8, 0) #fi)), extractMInt( getParentValue(R1, RSMap), 56, 64))
)

    </regstate>
    
endmodule

module SETP-RH-SEMANTICS
  imports SETP-RH
endmodule
