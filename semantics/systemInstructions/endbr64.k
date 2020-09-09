requires "x86-configuration.k"


module ENDBR64
  imports X86-CONFIGURATION

  // is considered a nop on legacy machine, 
  // for now we treat it as such
  rule 
    <k> 
        execinstr ( endbr64 .Operands) => . 
        ... 
    </k>

endmodule
