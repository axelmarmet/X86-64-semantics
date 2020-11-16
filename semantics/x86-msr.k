requires "x86-configuration.k"

module X86-MSR-SYNTAX

  imports X86-SYNTAX

  syntax Msr ::= "IA32_EFER"

endmodule

module X86-MSR

  imports X86-CONFIGURATION
  imports X86-SYNTAX

  rule <k>
    execinstr (wrmsr:Opcode .Operands) 
    =>
    .
    ...
    </k>
    <regstate> 
      RSMap:Map 
      => 
      RSMap[
        MSRMap[getRegisterValue(%ecx, RSMap)] <- 
        concatenateMInt(
          getRegisterValue(%edx, RSMap), 
          getRegisterValue(%eax, RSMap))]
    </regstate>
    <msrmapping> MSRMap:Map </msrmapping>
    requires getRegisterValue(%ecx, RSMap) in_keys(MSRMap)

  /* get the value of the MSR  */
  rule <k>
    execinstr (rdmsr:Opcode .Operands) 
    =>
    RSMap[MSRMap[getRegisterValue(%ecx, RSMap)]] ~> execinstr (rdmsr:Opcode .Operands)
    ...
    </k>
    <regstate> RSMap:Map </regstate>
    <msrmapping> MSRMap:Map </msrmapping>
    requires getRegisterValue(%ecx, RSMap) in_keys(MSRMap)

  /* put it in eax and edx */
  rule <k>
    MSRVal:MInt ~> execinstr (rdmsr:Opcode .Operands) 
    =>
    setRegisterValue(extractMask(MSRVal, 32, 0), %eax) ~>
    setRegisterValue(extractMask(MSRVal, 32, 32), %edx)
    ...
    </k>
    <regstate> RSMap:Map </regstate>
    <msrmapping> MSRMap:Map </msrmapping>
    requires getRegisterValue(%ecx, RSMap) in_keys(MSRMap)
    
endmodule