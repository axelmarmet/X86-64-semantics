require "x86-syntax.k"
require "x86-abstract-syntax.k"
require "common/common-memory.k"
require "x86-memory.k"
require "x86-env-init.k"
require "x86-mint-wrapper.k"

module X86-CONFIGURATION
  imports X86-SYNTAX
  imports X86-ABSTRACT-SYNTAX
  imports COMMON-MEMORY-CONFIGURATION
  imports X86-MEMORY-SYNTAX
  imports X86-INIT-SYNTAX
  imports MINT-WRAPPER-SYNTAX
  imports X86-LOADER-SYNTAX
  imports COMMON-C-LIBRARY-CONFIGURATION


  // configuration <T>
  configuration
//initEnvironment(ListItem("a.out") ListItem("HelloWorld!") .List) ~> 
    <k> 
	//initRegisters($REGV:RegValPairList) ~> 
	//initEnvironment($ARGV:List) ~> 
	initEnvironment(.List) ~> 
	$PGM:Lines ~> 
  loadEntryPoint ~>
	inforegisters ~> 
	fetch 
    </k>
    <entrypoint> mi(64, 1052672) </entrypoint>
    <exitpoint> mi(64, 1052677) </exitpoint>
    <functargets> .Map </functargets> 
    <rotargets> .Map </rotargets> 
    <datatargets> .Map </datatargets> 
    <bsstargets> .Map </bsstargets> 
    <nextLocPc> mi(64, 0) </nextLocPc>
    <lastseenlabel> .K </lastseenlabel>
    <currentsection> "text" </currentsection>

    <memstate>
      <text> code( .Map ) </text>
      <stack>
        <memory/>
        <stackbase> stackBaseInfo(.K, .K) </stackbase>
        <robase> roBaseInfo(.K /* Alocation id*/, .K /*Base Pointer*/, .K /*Next Location*/ ) </robase>
        <database> dataBaseInfo(.K , .K , .K ) </database>
        <bssbase>   bssBaseInfo(.K , .K , .K ) </bssbase>
      </stack>
    </memstate>

    <environment>
      <argc> .K </argc>
      <argv> .K </argv>
    </environment>

    <regstate>
      //.Map
      //REG 64
    ("RIP"    |-> mi(64, 0)) 
    ("RAX"    |-> mi(64, 0)) 
    ("RBX"    |-> mi(64, 0)) 
    ("RCX"    |-> mi(64, 0)) 
    ("RDX"    |-> mi(64, 0)) 
    ("RSI"    |-> mi(64, 0)) 
    ("RDI"    |-> mi(64, 0)) 
    ("RSP"    |-> mi(64, 0)) 
    ("RBP"    |-> mi(64, 0)) 
    ("R8"     |-> mi(64, 0)) 
    ("R9"     |-> mi(64, 0)) 
    ("R10"    |-> mi(64, 0)) 
    ("R11"    |-> mi(64, 0)) 
    ("R12"    |-> mi(64, 0)) 
    ("R13"    |-> mi(64, 0)) 
    ("R14"    |-> mi(64, 0)) 
    ("R15"    |-> mi(64, 0))
    //STATUS flags 
    ("CF"     |-> mi(1, 0)) 
    ("DF"     |-> mi(1, 0)) 
    ("PF"     |-> mi(1, 0)) 
    ("AF"     |-> mi(1, 0)) 
    ("ZF"     |-> mi(1, 0)) 
    ("SF"     |-> mi(1, 0)) 
    ("OF"     |-> mi(1, 0))
    //SYSTEM flags
    ("TF"     |-> mi(1, 0))   // Trap flag
    ("IF"     |-> mi(1, 0))   // Interrupt enable flag
    ("IOPL"     |-> mi(2, 0)) // I/O privilege level field
    ("NT"     |-> mi(1, 0))   // Nested task flag
    ("RF"     |-> mi(1, 0))   // Resume flag
    ("VM"     |-> mi(1, 0))   // Virtual-8086 mode flag
    ("AC"     |-> mi(1, 0))   // Alignment check flag
    ("VIF"     |-> mi(1, 0))  // Virtual interrupt flag
    ("VIP"     |-> mi(1, 0))  // Virtual interrupt pending flag
    ("ID"     |-> mi(1, 0))   // Identification flag
    //CR0 bits 
    ("PG"     |-> mi(1, 0))   // Paging
    ("CD"     |-> mi(1, 0))   // Cache Disable
    ("NW"     |-> mi(1, 0))   // Not Write-through
    ("AM"     |-> mi(1, 0))   // Alignment Mask
    ("WP"     |-> mi(1, 0))   // Write Protect
    ("NE"     |-> mi(1, 0))   // Numeric Error
    ("ET"     |-> mi(1, 0))   // Extension Type
    ("TS"     |-> mi(1, 0))   // Task switched
    ("EM"     |-> mi(1, 0))   // Emulation
    ("MP"     |-> mi(1, 0))   // Monitor Coprocessor
    ("PE"     |-> mi(1, 0))   // Protection Enable
    //CR2 
    ("CR2"    |-> mi(32, 0))
    //CR3 bits
    ("PageDirectoryBase" |-> mi(20, 0))
    ("PCD"     |-> mi(1, 0))  // Page-level Cache Disable
    ("PWT"     |-> mi(1, 0))  // Page-level Write-through
    //CR4
    ("VME"     |-> mi(1, 0))   // Virtual-8086 Mode Extensions
    ("PVI"     |-> mi(1, 0))   // Protected-Mode Virtual Interrupts
    ("TSD"     |-> mi(1, 0))   // Time Stamp Disable
    ("DE"     |-> mi(1, 0))    // Debugging Extensions
    ("PSE"     |-> mi(1, 0))   // Page Size Extensions
    ("PAE"     |-> mi(1, 0))   // Physical Address Extension
    ("MCE"     |-> mi(1, 0))   // Machine-Check Enable
    ("PGE"     |-> mi(1, 0))   // Page Global Enable
    ("PCE"     |-> mi(1, 0))   // Performance-Monitoring Counter Enable
    ("OSFXSR"     |-> mi(1, 0)) // Operating System Support for FXSAVE and FXRSTOR instructions
    ("OSXMMEXCPT"     |-> mi(1, 0)) // Operating System Support for Unmasked SIMD Floating-Point Exceptions
    ("UMIP"     |-> mi(1, 0))  // User-Mode Instruction Prevention
    ("VMXE"     |-> mi(1, 0))  // VMX-Enable Bit
    ("SMXE"     |-> mi(1, 0))  // SMX-Enable Bit
    ("FSGBASE"     |-> mi(1, 0))  // FSGBASE-Enable Bit
    ("PCIDE"     |-> mi(1, 0))  // PCID-Enable Bit
    ("OSXSAVE"     |-> mi(1, 0))  // XSAVE and Processor Extended States-Enable Bit
    ("SMEP"     |-> mi(1, 0))  // SMEP-Enable Bit
    ("SMAP"     |-> mi(1, 0))  // SMAP-Enable Bit
    ("PKE"     |-> mi(1, 0))  // Protection-Key-Enable Bit
    //CR8
    ("TPL"     |-> mi(4, 0))  // Task Priority Level
    //AVX regs
    ("YMM0"   |->  mi(256, 0)) 
    ("YMM1"   |->  mi(256, 0)) 
    ("YMM2"   |->  mi(256, 0)) 
    ("YMM3"   |->  mi(256, 0)) 
    ("YMM4"   |->  mi(256, 0)) 
    ("YMM5"   |->  mi(256, 0)) 
    ("YMM6"   |->  mi(256, 0)) 
    ("YMM7"   |->  mi(256, 0)) 
    ("YMM8"   |->  mi(256, 0)) 
    ("YMM9"   |->  mi(256, 0)) 
    ("YMM10"  |->  mi(256, 0)) 
    ("YMM11"  |->  mi(256, 0)) 
    ("YMM12"  |->  mi(256, 0)) 
    ("YMM13"  |->  mi(256, 0)) 
    ("YMM14"  |->  mi(256, 0)) 
    ("YMM15"  |->  mi(256, 0))
    </regstate>

    /*@
      The following configuration is used to store the intermediate
      regstate at instruction boundary. Used in debug/testing purposes.

      itracer: For debug purposes
      regstatequeue: For testing purposes
    */

    // <itracer> .List </itracer>
    <regstatequeue> .List </regstatequeue>

    <formatcountint> 0 </formatcountint>
    <formatcountfloat> 0 </formatcountfloat>
    <c-library/>
    <formatting/>
endmodule
