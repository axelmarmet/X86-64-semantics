requires "x86-configuration.k"


module RETQ
  imports X86-CONFIGURATION

  rule <k> 
    execinstr (leave .Operands) => 
      execinstr(movq %rbp, %rsp, .Operands) ~> 
      execinstr(popq %rbp, .Operands)
  ...</k>
endmodule
