// Autogenerated using stratification.
requires "x86-configuration.k"

module VHSUBPD-YMM-YMM-YMM
  imports X86-CONFIGURATION

  rule <k>
    execinstr (vhsubpd R1:Ymm, R2:Ymm, R3:Ymm,  .Operands) => .
  ...</k>
    <regstate>
RSMap:Map => updateMap(RSMap,
convToRegKeys(R3) |-> concatenateMInt( concatenateMInt( sub_double(extractMInt( getParentValue(R1, RSMap), 64, 128), extractMInt( getParentValue(R1, RSMap), 0, 64)), sub_double(extractMInt( getParentValue(R2, RSMap), 64, 128), extractMInt( getParentValue(R2, RSMap), 0, 64))), concatenateMInt( sub_double(extractMInt( getParentValue(R1, RSMap), 192, 256), extractMInt( getParentValue(R1, RSMap), 128, 192)), sub_double(extractMInt( getParentValue(R2, RSMap), 192, 256), extractMInt( getParentValue(R2, RSMap), 128, 192))))
)

    </regstate>
    
endmodule

module VHSUBPD-YMM-YMM-YMM-SEMANTICS
  imports VHSUBPD-YMM-YMM-YMM
endmodule
