requires "x86-configuration.k"


/*@
  Push R: 
  1. ValTostore = R
  2. *(RSP-4)  = ValTostore
  3. RSP = RSP - 4
*/  
module PUSHL-R32
  imports X86-CONFIGURATION

  rule <k> 
    execinstr (pushl R1:R32, .Operands) =>
      storeToMemory(
          getRegisterValue(R1, RSMap), 
          subMInt(getRegisterValue(%rsp, RSMap), mi(64, 4)), 
          32)  ~>  
      decRSPInBytes(4)
  ...</k>
  <regstate> RSMap </regstate>
  <processormode> b32 </processormode>

endmodule
