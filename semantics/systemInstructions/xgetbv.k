requires "x86-configuration.k"

module XGETBV

  imports X86-CONFIGURATION

  /* get the value of XCR0  */
  rule <k>
    execinstr (xgetbv:Opcode .Operands) 
    =>
    getXCR0(RSMap) ~> execinstr (xgetbv:Opcode .Operands)
    ...
    </k>
    <regstate> RSMap:Map </regstate>
    requires  getCPL(RSMap) ==Int 0 andBool
              uvalueMInt(getRegisterValue(%ecx, RSMap)) ==Int 0
  /* put it in eax and edx */
  rule <k>
    XCR0Val:MInt ~> execinstr (xgetbv:Opcode .Operands) 
    =>
    setRegisterValue(extractMask(XCR0Val, 32, 0), %eax) ~>
    setRegisterValue(extractMask(XCR0Val, 32, 32), %edx)
    ...
    </k>
    <regstate> RSMap:Map </regstate>
    requires getCPL(RSMap) ==Int 0 andBool
              uvalueMInt(getRegisterValue(%ecx, RSMap)) ==Int 0
    
endmodule