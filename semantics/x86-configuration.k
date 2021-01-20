require "x86-syntax.k"
require "x86-abstract-syntax.k"
require "common/common-memory.k"
require "x86-memory.k"
require "x86-mint-wrapper.k"

module X86-CONFIGURATION
  imports X86-SYNTAX
  imports X86-ABSTRACT-SYNTAX
  imports COMMON-MEMORY-CONFIGURATION
  imports X86-MEMORY-SYNTAX
  imports MINT-WRAPPER-SYNTAX
  imports X86-LOADER-SYNTAX


  configuration
    <k>  
	$PGM:Lines ~> 
  loadEntryPoint ~>
	inforegisters ~>
	fetch
  //setControlRegisterValue ( mi(64,2097222) , %eflags )
    </k>
    <entrypoint> mi(64, 1052672) </entrypoint>
    <exitpoint> mi(64, 1056836) </exitpoint>
    <functargets> .Map </functargets> 
    <rotargets> .Map </rotargets> 
    <datatargets> .Map </datatargets> 
    <bsstargets> .Map </bsstargets> 
    <nextLocPc> mi(64, 0) </nextLocPc>
    <lastseenlabel> .K </lastseenlabel>
    <currentsection> "text" </currentsection>

    <sizeHint> hint(.Map) </sizeHint>
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

    //obtained by running cpuid on lenovo t480
    <cpuidinfo>
      <processorsignature> 
        ("family" |-> mi(4, 6)) 
        ("model" |-> mi(4, 14)) 
        ("stepping" |-> mi(4, 10)) 
        ("processortype" |-> mi(2, 0)) 
        ("extendedmodel" |-> mi(4, 8)) 
        ("extendedfamily" |-> mi(8, 0)) 
      </processorsignature>
      <extendedfunctioninfo>
        ("LAHF64"    |-> mi(1,0))
        ("LZCNT"     |-> mi(1,0))
        ("PREFETCHW" |-> mi(1,0))
        ("SYSCALL"   |-> mi(1,0))
        ("EDB"       |-> mi(1,0))
        ("1GBAv"     |-> mi(1,1))
        ("RDTSCP"    |-> mi(1,0))
        ("64MODEAv"  |-> mi(1,1))
      </extendedfunctioninfo>
      <supportedfeatures>
        ("RDRAND" |-> mi(1,1))
        ("F16C" |-> mi(1,1))
        ("AVX" |-> mi(1,1))
        ("OSXSAVE" |-> mi(1,0))
        ("XSAVE" |-> mi(1,1))
        ("AES" |-> mi(1,1))
        ("TSC_Deadline" |-> mi(1,0))
        ("POPCNT" |-> mi(1,1))
        ("MOVBE" |-> mi(1,0))
        ("x2APIC" |-> mi(1,0))
        ("SSE4_2" |-> mi(1,1)) 
        ("SSE4_1" |-> mi(1,1)) 
        ("DCA" |-> mi(1,0)) 
        ("PCID" |-> mi(1,0)) 
        ("PDCM" |-> mi(1,0)) 
        ("xTPR" |-> mi(1,0)) 
        ("CMPXCHG16B" |-> mi(1,1))
        ("FMA" |-> mi(1,0)) 
        ("SDBG" |-> mi(1,0)) 
        ("CNXT_ID" |-> mi(1,0)) 
        ("SSSE3" |-> mi(1,1)) 
        ("TM2" |-> mi(1,0)) 
        ("EIST" |-> mi(1,0)) 
        ("SMX" |-> mi(1,0)) 
        ("VMX" |-> mi(1,0)) 
        ("DS_CPL" |-> mi(1,0)) 
        ("MONITOR" |-> mi(1,0)) 
        ("DTES64" |-> mi(1,0)) 
        ("PCLMULQDQ" |-> mi(1,1)) 
        ("SSE3" |-> mi(1,1)) 
        
        ("PBE" |-> mi(1,0)) 
        ("TM" |-> mi(1,0)) 
        ("HTT" |-> mi(1,0)) 
        ("SS" |-> mi(1,1)) 
        ("SSE2" |-> mi(1,1)) 
        ("SSE" |-> mi(1,1)) 
        ("FXSR" |-> mi(1,1)) 
        ("MMX" |-> mi(1,1)) 
        ("ACPI" |-> mi(1,0)) 
        ("DS" |-> mi(1,0)) 
        ("CLFSH" |-> mi(1,0)) 
        ("PSN" |-> mi(1,0)) 
        ("PSE_36" |-> mi(1,0)) 
        ("PAT" |-> mi(1,0)) 
        ("CMOV" |-> mi(1,0)) 
        ("MCA" |-> mi(1,0)) 
        ("PGE" |-> mi(1,0)) 
        ("MTRR" |-> mi(1,0)) 
        ("SEP" |-> mi(1,0)) 
        ("APIC" |-> mi(1,0)) 
        ("CX8" |-> mi(1,1)) 
        ("MCE" |-> mi(1,0)) 
        ("PAE" |-> mi(1,1)) 
        ("MSR" |-> mi(1,1)) 
        ("TSC" |-> mi(1,1)) 
        ("PSE" |-> mi(1,0)) 
        ("DE" |-> mi(1,0)) 
        ("VME" |-> mi(1,0)) 
        ("FPU" |-> mi(1,1)) 
      </supportedfeatures>
      <supportedextendedfeatures>
        ("FSGSBASE" |-> mi(1,1)) //Supports RDFSBASE/RDGSBASE/WRFSBASE/WRGSBASE if 1.
        ("INV_TSC" |-> mi(1,1)) //Invariant TSC available if 1.
      </supportedextendedfeatures>

      <maxbasicleaf> mi(32, 7) </maxbasicleaf>
      <maxextendedleaf> mi(32, 2147483655) </maxextendedleaf> 
    </cpuidinfo>
    

    <cpuidavailable> true </cpuidavailable>

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
      ("PF"     |-> mi(1, 1)) 
      ("AF"     |-> mi(1, 0)) 
      ("ZF"     |-> mi(1, 1)) 
      ("SF"     |-> mi(1, 0)) 
      ("OF"     |-> mi(1, 0))
      ("ID"     |-> mi(1,0))
      ("VIP"    |-> mi(1,0))
      ("VIF"    |-> mi(1,0))
      ("AC"     |-> mi(1,0))
      ("VM"     |-> mi(1,0))
      ("RF"     |-> mi(1,0))
      ("NT"     |-> mi(1,0))
      ("IOPL"    |-> mi(2,0))
      ("IF"     |-> mi(1,0))
      ("TF"     |-> mi(1,0))
      //CR0 bits 
      ("PG"     |-> mi(1, 0))   // Paging
      ("CD"     |-> mi(1, 0))   // Cache Disable
      ("NW"     |-> mi(1, 0))   // Not Write-through
      ("AM"     |-> mi(1, 0))   // Alignment Mask
      ("WP"     |-> mi(1, 0))   // Write Protect
      ("NE"     |-> mi(1, 0))   // Numeric Error
      ("ET"     |-> mi(1, 1))   // Extension Type
      ("TS"     |-> mi(1, 0))   // Task switched
      ("EM"     |-> mi(1, 0))   // Emulation
      ("MP"     |-> mi(1, 0))   // Monitor Coprocessor
      ("PE"     |-> mi(1, 1))   // Protection Enable
      //CR2 
      ("CR2"    |-> mi(32, 0))
      //CR3 bits
      ("PageDirectoryBase" |-> mi(40, 0))
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
      ("FSGSBASE"     |-> mi(1, 0))  // FSGBASE-Enable Bit
      ("PCIDE"     |-> mi(1, 0))  // PCID-Enable Bit
      ("OSXSAVE"     |-> mi(1, 0))  // XSAVE and Processor Extended States-Enable Bit
      ("SMEP"     |-> mi(1, 0))  // SMEP-Enable Bit
      ("SMAP"     |-> mi(1, 0))  // SMAP-Enable Bit
      ("PKE"     |-> mi(1, 0))  // Protection-Key-Enable Bit
      //CR8
      ("TPL"     |-> mi(4, 0))  // Task Priority Level
      //XCR0
      ("PKRU_state" |-> mi(1,0))
      ("Hi16_ZMM_state" |-> mi(1,0))
      ("ZMM_Hi256_state" |-> mi(1,0))
      ("Opmask_state" |-> mi(1,0))
      ("BNDCSR_state" |-> mi(1,0))
      ("BNDREG_state" |-> mi(1,0))
      ("AVX_state" |-> mi(1,0))
      ("SSE_state" |-> mi(1,0))
      ("x87_FPU_MMX_state" |-> mi(1,0))
      //MSR
      ("IA32_EFER" |-> mi(64, 0))
      //SEGMENTS
      ("CS" |-> mi(64,0))
      ("DS" |-> mi(64,0))
      ("SS" |-> mi(64,0))
      ("ES" |-> mi(64,0))
      ("FS" |-> mi(64,0))
      ("GS" |-> mi(64,0))
      ("GDTR_BASE" |-> mi(64,0))
      ("GDTR_LIMIT" |-> mi(16,0))
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

    <msrmapping>
      (mi(32, 3221225600) |-> "IA32_EFER")
    </msrmapping>

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
endmodule
