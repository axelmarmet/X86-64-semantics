requires "x86-configuration.k"


module RETQ
  imports X86-CONFIGURATION

  rule <k> 
    execinstr (lgdtl H:HexConstant, .Operands) => . ...</k>
  <processormode> b64 </processormode>

endmodule
