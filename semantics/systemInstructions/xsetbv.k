requires "x86-configuration.k"

module XSETBV

  imports X86-CONFIGURATION

    rule <k>
        execinstr (xsetbv:Opcode .Operands) 
        =>
        concatenateMInt(
               getRegisterValue(%edx, RSMap), 
               getRegisterValue(%eax, RSMap))  ~>
        execinstr (xsetbv:Opcode .Operands) ...
    </k>
    <regstate> RSMap </regstate>
    requires  getCPL(RSMap) ==Int 0 andBool
              uvalueMInt(getRegisterValue(%ecx, RSMap)) ==Int 0

    rule <k>
        M:MInt ~> execinstr (xsetbv:Opcode .Operands) 
        =>
        setXCR0( M) ...
    </k>
    <regstate> RSMap </regstate>
    requires  getCPL(RSMap) ==Int 0 andBool
              uvalueMInt(getRegisterValue(%ecx, RSMap)) ==Int 0
         
endmodule