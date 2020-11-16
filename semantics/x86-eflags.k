requires "x86-configuration.k"

module X86-EFLAGS-SYNTAX

  imports X86-CONFIGURATION

  syntax MInt ::= getTF(Map) 
  syntax MInt ::= getIF(Map) 
  syntax MInt ::= getDF(Map) 
  syntax MInt ::= getOF(Map) 
  syntax MInt ::= getIOPL(Map) 
  syntax MInt ::= getNT(Map) 
  syntax MInt ::= getRF(Map) 
  syntax MInt ::= getVM(Map) 
  syntax MInt ::= getAC(Map) 
  syntax MInt ::= getVIF(Map) 
  syntax MInt ::= getVIP(Map) 
  syntax MInt ::= getID(Map) 

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

  syntax KItem ::= updateEFLAGS(MInt /*old value */,
                                MInt /*new value */)
  
  syntax MInt ::= extractLoadValue(KItem) [function]
  rule extractLoadValue(memLoadValue(MI:MInt)) => MI

  rule eflagsMask => mi(32, hexToInt(0x00FCFFFF)) [macro]
  rule cpuidMask => mi(32, 1 <<Int 21) [macro]
  rule popUnchangedMask => mi(32, (1 <<Int 20) |Int (1 <<Int 19) |Int (1 <<Int 17)) [macro]
  rule popZeroedMask => negMInt(mi(32, (1 <<Int 16))) [macro]
  
  rule getRegisterValue(R:RControl, RSMap) => {RSMap[convToRegKeys(R)]}:>MInt

  rule 
    <k>
      updateEFLAGS(Old:MInt, New:MInt) => . ...
    </k>
    <cpuidavailable> true </cpuidavailable>
    <regstate> 
      RSMap:Map => updateMap(RSMap, 
        "EFLAGS" |-> New
        "CF"     |-> extractMInt(New, 1, 0)
        "PF"     |-> extractMInt(New, 3, 2)
        "AF"     |-> extractMInt(New, 5, 4)
        "ZF"     |-> extractMInt(New, 7, 6)
        "SF"     |-> extractMInt(New, 8, 7)
        "OF"     |-> extractMInt(New, 12, 11)
      )
    </regstate>
  rule 
    <k>
      updateEFLAGS(Old:MInt, New:MInt) => . ...
    </k>
    <cpuidavailable> false </cpuidavailable>
    <regstate> 
      RSMap:Map => updateMap(RSMap, 
        "EFLAGS" |-> updateExceptMask(Old, New, cpuidMask)
        "CF"     |-> extractMInt(New, 1, 0)
        "PF"     |-> extractMInt(New, 3, 2)
        "AF"     |-> extractMInt(New, 5, 4)
        "ZF"     |-> extractMInt(New, 7, 6)
        "SF"     |-> extractMInt(New, 8, 7)
        "OF"     |-> extractMInt(New, 12, 11)
      )
    </regstate>
    //if cpuid is not a valid instruction then bit ID cannot be toggled or cleared

  rule getTF(RSMap) => extractMInt(getRegisterValue(%eflags, RSMap), 9, 8)   // Trap flag
  rule getIF(RSMap) => extractMInt(getRegisterValue(%eflags, RSMap), 10, 9)   // Interrupt enable flag
  rule getDF(RSMap) => extractMInt(getRegisterValue(%eflags, RSMap), 11, 10)   // Direction flag
  rule getOF(RSMap) => extractMInt(getRegisterValue(%eflags, RSMap), 12, 11)   // Overflow flag
  rule getIOPL(RSMap) => extractMInt(getRegisterValue(%eflags, RSMap), 14, 12) // I/O privilege level field
  rule getNT(RSMap) => extractMInt(getRegisterValue(%eflags, RSMap), 15, 14)   // Nested task flag
  rule getRF(RSMap) => extractMInt(getRegisterValue(%eflags, RSMap), 17, 16)   // Resume flag
  rule getVM(RSMap) => extractMInt(getRegisterValue(%eflags, RSMap), 18, 17)   // Virtual-8086 mode flag
  rule getAC(RSMap) => extractMInt(getRegisterValue(%eflags, RSMap), 19, 18)   // Alignment check flag
  rule getVIF(RSMap) => extractMInt(getRegisterValue(%eflags, RSMap), 20, 19)  // Virtual interrupt flag
  rule getVIP(RSMap) => extractMInt(getRegisterValue(%eflags, RSMap), 21, 20)  // Virtual interrupt pending flag
  rule getID(RSMap) => extractMInt(getRegisterValue(%eflags, RSMap), 22, 21)   // Identification flag

  rule <k> 
    execinstr (pushfd:Opcode .Operands) =>
      storeToMemory(
          andMInt(
              getEFLAGSValue(RSMap),
              eflagsMask), 
          subMInt(getRegisterValue(%rsp, RSMap), mi(32, 4)), 
          32)  ~>  
      decRSPInBytes(4)
  ...</k>
  <regstate> RSMap </regstate>
  <processormode> b32 </processormode>
  requires isProtectedMode(RSMap) andBool (notBool(isVirtual8086Mode(RSMap)))

  rule <k>
    execinstr (popfd:Opcode .Operands) => 
      incRSPInBytes(4) ~>
      updateEFLAGS(
          {RSMap["EFLAGS"]}:>MInt,
          updateExceptMask(
            {RSMap["EFLAGS"]}:>MInt,
            andMInt(
              extractLoadValue(
                loadFromMemory(getRegisterValue(%rsp, RSMap), 32)), 
              popZeroedMask),
            popUnchangedMask)) 
           ... 
    </k>
    <regstate> RSMap </regstate>
    <processormode> b32 </processormode>
    requires isProtectedMode(RSMap) andBool 
             (notBool(isVirtual8086Mode(RSMap))) andBool
             getCPL(RSMap) ==Int 0

endmodule