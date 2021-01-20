requires "x86-configuration.k"

module X86-EFLAGS-SYNTAX

  imports X86-SYNTAX

  syntax MInt ::= extractLoadValue(KItem) [function, strict]
  syntax MInt ::= strictAndMInt(MInt, MInt) [function, strict]


endmodule

module X86-EFLAGS

  imports X86-CONFIGURATION
  imports COMMON-UTILS-SYNTAX
  imports X86-EFLAGS-SYNTAX
  imports X86-ABSTRACT-SEMANTICS

  syntax MInt ::= "eflagsMask" 
                | "cpuidMask" 
                | "popUnchangedMask"
                | "popZeroedMask"

  syntax MInt ::= popUnchangedMask(Bool) [function]


  // syntax MInt ::= strictAndMInt(MInt, MInt) [function, strict]
  rule strictAndMInt(M1:MInt, M2:MInt) => andMInt(M1, M2)
  
  rule extractLoadValue(memLoadValue(MI:MInt)) => MI

  rule eflagsMask => mi(32, hexToInt(0x00FCFFFF)) [macro]
  rule cpuidMask => mi(32, 1 <<Int 21) [macro]

  rule popUnchangedMask(B:Bool) => 
    #if B 
      #then mi(32, (1 <<Int 20) |Int (1 <<Int 19) |Int (1 <<Int 17)) 
      #else mi(32, (1 <<Int 21) |Int (1 <<Int 20) |Int (1 <<Int 19) |Int (1 <<Int 17)) 
    #fi

  rule popZeroedMask => negMInt(mi(32, (1 <<Int 16))) [macro]
  

  //if cpuid is not a valid instruction then bit ID cannot be toggled or cleared

  rule execinstr ((pushfd:Opcode => pushf) .Operands)
  rule execinstr ((pushfq:Opcode => pushf) .Operands)
  rule execinstr ((pushfl:Opcode => pushf) .Operands)

  rule execinstr ((popfd:Opcode => popf) .Operands)
  rule execinstr ((popfq:Opcode => popf) .Operands)
  rule execinstr ((popfl:Opcode => popf) .Operands)

  rule <k> 
    execinstr (pushf:Opcode .Operands) =>
      storeToMemory(
          andMInt(
              extractMask(getControlRegisterValue(%eflags, RSMap), 32, 0),
              eflagsMask), 
          subMInt(getRegisterValue(%rsp, RSMap), mi(64, 4)), 
          32)  ~>  
      decRSPInBytes(4)
  ...</k>
  <regstate> RSMap </regstate>
  requires in32Bits(RSMap) andBool isProtectedMode(RSMap) andBool (notBool(isVirtual8086Mode(RSMap)))

  rule <k>
      execinstr (popf:Opcode .Operands) => 
      loadFromMemory(getRegisterValue(%rsp, RSMap), 32) ~> execinstr (popf .Operands) ...
    </k>
    <regstate> RSMap </regstate>
    requires in32Bits(RSMap) andBool
             isProtectedMode(RSMap) andBool 
             (notBool(isVirtual8086Mode(RSMap))) andBool
             (getCPL(RSMap) ==Int 0)

  rule <k>
      memLoadValue(NewEflags:MInt):MemLoadValue ~> execinstr(popf:Opcode .Operands) =>
      extractMask(getControlRegisterValue(%eflags, RSMap), 32, 0) ~> execinstr(popf NewEflags, .Operands) ...
    </k>
    <regstate> RSMap </regstate>
    requires in32Bits(RSMap) andBool
             isProtectedMode(RSMap) andBool 
             (notBool(isVirtual8086Mode(RSMap))) andBool
             (getCPL(RSMap) ==Int 0)

  rule <k> OldEflags:MInt ~> execinstr(popf:Opcode NewEflags:MInt, .Operands) =>
    incRSPInBytes(4) ~>
    setControlRegisterValue(
        updateExceptMask(
          OldEflags,
          andMInt(
            NewEflags,
            popZeroedMask
          ),
          popUnchangedMask(Available)),
      %eflags) ...
    </k>
    <cpuidavailable> Available </cpuidavailable>
    <regstate> RSMap </regstate>
    requires in32Bits(RSMap) andBool
             isProtectedMode(RSMap) andBool 
             (notBool(isVirtual8086Mode(RSMap))) andBool
             (getCPL(RSMap) ==Int 0)

 

endmodule