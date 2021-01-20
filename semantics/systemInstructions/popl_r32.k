requires "x86-configuration.k"

/*@
  Pop R: 
  1. RSP = RSP + 4
  2. ValTostore = *(RSP - 4)
  3. R =  ValTostore)
*/  
module POPL-R32
  imports X86-CONFIGURATION

  rule <k> 
    execinstr (popl R1:R32, .Operands) =>
      incRSPInBytes(4) ~>
      setRegisterValue(
          loadFromMemory(getRegisterValue(%rsp, RSMap), 32), 
          R1) 
  ...</k>
  <regstate> RSMap </regstate>
  requires in32Bits(RSMap)

endmodule
