require "x86-syntax.k"
requires "x86-configuration.k"

module X86-FETCH-EXECUTE
  imports X86-CONFIGURATION
  imports X86-SYNTAX
  syntax KItem ::= "decode" [token]

  /*@
    Fetch the instructions from Code memory for exection & debugging.
  */
  // rule
  //   <k> fetch => execinstr(OpC OpR) ~> inforegisters ~> fetch ... </k>
  //     //<text>code(iloc(PC) |-> storedInstr(OpC OpR) _:Map) </text>
  //     <text>code(VirtAddr:MInt |-> storedInstr(OpC OpR) _:Map) </text>
  //     //<regstate>... "RIP" |-> ( PC => addMInt(PC,  mi(64, 1)))  ...</regstate>
  //     <regstate>... "RIP" |-> ( VirtAddr => addMInt(VirtAddr,  ptr(getMemLoc(PV), mi(64, 1))))  ...</regstate>

  /*
    Fetch machine code in memory
   */
  rule
    <k> 
      fetch => loadFromMemory(VirtAddr, 8) ~> decode ~> inforegisters ~> fetch
    </k>
    <exitpoint> ExitPoint </exitpoint>
    <regstate>
      ... "RIP" |-> VirtAddr  ...
    </regstate>
    requires notBool (uvalueMInt(VirtAddr) ==Int uvalueMInt(ExitPoint))

  rule
    <k>
      memLoadValue(Val:MInt):MemLoadValue ~> decode => CMap[Val] ...
    </k>
    <text>
      code (CMap)
    </text>
    <regstate>
      ... "RIP" |-> (VirtAddr => addMInt(VirtAddr, mi(64, bitwidthMInt(Val) /Int 8))) ...
    </regstate>
    requires Val in_keys ( CMap )

  rule
    <k>
      (memLoadValue(Val:MInt):MemLoadValue => loadFromMemoryAcross(VirtAddr, bitwidthMInt(Val) +Int 8)) ~> decode ...
    </k>
    <text>
      code (CMap)
    </text>
    <regstate>
      ... "RIP" |-> VirtAddr  ...
    </regstate>
    requires notBool Val in_keys ( CMap )


  /*@ 
    After execution of last instrcution, no more fecthes. 
    The last return instruction drive the PC to an invalid location
    (out of code section)
  */
  rule
    <k> fetch => .  ... </k>
    <text> code (CMap) </text>
    <exitpoint> ExitPoint:MInt </exitpoint>
    <regstate> ... "RIP" |-> ExitPoint </regstate>


  /*@
    The variants of fetch without debugging support.
  */
  rule
    <k> fetchNoDBG => execinstr(OpC OpR) ~> fetchNoDBG ... </k>
      <text>code(PV:PointerVal |-> storedInstr(OpC OpR) _:Map) </text>
      <regstate>... "RIP" |-> ( PV => addMInt(PV,  ptr(getMemLoc(PV), mi(64, 1))))  ...</regstate>

  rule
    <k> fetchNoDBG => .  ... </k>
      <text> code (CMap) </text>
      <regstate> RSMap </regstate>
        requires notBool  {RSMap["RIP"]}:>PointerVal  in_keys ( CMap )

  /*@
    inforegisters prints all the register states for debug purposes.
  */
  rule
    <k> inforegisters => . ... </k>
      //<regstatequeue> ... .List => ListItem(RSMap) ListItem(FMap) </regstatequeue>
      <regstatequeue> ... .List => ListItem(RSMap) </regstatequeue>
      <regstate> RSMap </regstate>
      <functargets> FMap:Map </functargets>
      <text> code (CMap) </text>
        //requires  iloc( {RSMap["RIP"]}:>MInt ) in_keys ( CMap )
        requires  {RSMap["RIP"]}:>PointerVal  in_keys ( CMap )

  rule
    <k> inforegisters => . ... </k>
      <regstatequeue> ... .List => ListItem(RSMap) ListItem(FMap) </regstatequeue>
      <text> code (CMap) </text>
      <regstate> RSMap </regstate>
      <functargets> FMap:Map </functargets>
        //requires notBool iloc( {RSMap["RIP"]}:>MInt ) in_keys ( CMap )
        requires notBool {RSMap["RIP"]}:>PointerVal  in_keys ( CMap )

  /*@
    Final Exit.
  */
  syntax KItem ::= "exit_0"
  rule <k> .K => exit_0 </k>

endmodule
