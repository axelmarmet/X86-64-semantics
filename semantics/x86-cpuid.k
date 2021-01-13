requires "x86-configuration.k"

module X86-CPUID

  imports X86-CONFIGURATION

  syntax KItem ::= writeCpuIdRes(/* EAX */MInt, 
                                 /* EBX */MInt, 
                                 /* ECX */MInt, 
                                 /* EDX */MInt)

  syntax MInt ::= getFeatureInformationECX(Map) [function]
  rule getFeatureInformationECX(FeatMap:Map) =>
    concatenateMInts(
      mi(1,0)
      {FeatMap["RDRAND"]}:>MInt
      {FeatMap["F16C"]}:>MInt
      {FeatMap["AVX"]}:>MInt
      {FeatMap["OSXSAVE"]}:>MInt
      {FeatMap["XSAVE"]}:>MInt
      {FeatMap["AES"]}:>MInt
      {FeatMap["TSC_Deadline"]}:>MInt
      {FeatMap["POPCNT"]}:>MInt
      {FeatMap["MOVBE"]}:>MInt
      {FeatMap["x2APIC"]}:>MInt
      {FeatMap["SSE4_2"]}:>MInt
      {FeatMap["SSE4_1"]}:>MInt
      {FeatMap["DCA"]}:>MInt
      {FeatMap["PCID"]}:>MInt
      mi(1,0)
      {FeatMap["PDCM"]}:>MInt
      {FeatMap["xTPR"]}:>MInt
      {FeatMap["CMPXCHG16B"]}:>MInt
      {FeatMap["FMA"]}:>MInt
      {FeatMap["SDBG"]}:>MInt
      {FeatMap["CNXT_ID"]}:>MInt
      {FeatMap["SSSE3"]}:>MInt
      {FeatMap["TM2"]}:>MInt
      {FeatMap["EIST"]}:>MInt
      {FeatMap["SMX"]}:>MInt
      {FeatMap["VMX"]}:>MInt
      {FeatMap["DS_CPL"]}:>MInt
      {FeatMap["MONITOR"]}:>MInt
      {FeatMap["DTES64"]}:>MInt
      {FeatMap["PCLMULQDQ"]}:>MInt
      {FeatMap["SSE3"]}:>MInt
    )

  syntax MInt ::= getFeatureInformationEDX(Map) [function]
  rule getFeatureInformationEDX(FeatMap:Map) =>
    concatenateMInts(
      {FeatMap["PBE"]}:>MInt
      mi(1,0)
      {FeatMap["TM"]}:>MInt
      {FeatMap["HTT"]}:>MInt
      {FeatMap["SS"]}:>MInt
      {FeatMap["SSE2"]}:>MInt
      {FeatMap["SSE"]}:>MInt
      {FeatMap["FXSR"]}:>MInt
      {FeatMap["MMX"]}:>MInt
      {FeatMap["ACPI"]}:>MInt
      {FeatMap["DS"]}:>MInt
      mi(1,0)
      {FeatMap["CLFSH"]}:>MInt
      {FeatMap["PSN"]}:>MInt
      {FeatMap["PSE_36"]}:>MInt
      {FeatMap["PAT"]}:>MInt
      {FeatMap["CMOV"]}:>MInt
      {FeatMap["MCA"]}:>MInt
      {FeatMap["PGE"]}:>MInt
      {FeatMap["MTRR"]}:>MInt
      {FeatMap["SEP"]}:>MInt
      mi(1,0)
      {FeatMap["APIC"]}:>MInt
      {FeatMap["CX8"]}:>MInt
      {FeatMap["MCE"]}:>MInt
      {FeatMap["PAE"]}:>MInt
      {FeatMap["MSR"]}:>MInt
      {FeatMap["TSC"]}:>MInt
      {FeatMap["PSE"]}:>MInt
      {FeatMap["DE"]}:>MInt
      {FeatMap["VME"]}:>MInt
      {FeatMap["FPU"]}:>MInt
    )
  syntax MInt ::= getProcessorSignature(Map) [function]
  rule  getProcessorSignature(SigMap:Map) =>
    concatenateMInts(
        mi(4,0)
        {SigMap["extendedfamily"]}:>MInt
        {SigMap["extendedmodel"]}:>MInt
        mi(2,0)
        {SigMap["processortype"]}:>MInt
        {SigMap["family"]}:>MInt
        {SigMap["model"]}:>MInt
        {SigMap["stepping"]}:>MInt
    )

  rule <k>
        execinstr (cpuid:Opcode .Operands) 
        =>
        //EAX has max basic leaf supported,
        //EBX, ECX, EDX spell "GenuineIntel"
        writeCpuIdRes(M, 
                      mi(32, 1970169159),
                      mi(32, 1818588270),
                      mi(32, 1231384169))
        ...
    </k>
    <maxbasicleaf> M:MInt </maxbasicleaf>
    <regstate>
        ... "RAX" |-> mi(64, 0) ...
    </regstate>

  rule <k>
        execinstr (cpuid:Opcode .Operands) 
        =>
        writeCpuIdRes(mi(32, 0), // false for now 
                      mi(32, 0), // false for now
                      getFeatureInformationECX(FeatMap),
                      getFeatureInformationEDX(FeatMap)) 
        ...
    </k>
    <supportedfeatures> FeatMap:Map </supportedfeatures>
    <regstate>
        ... "RAX" |-> mi(64, 1) ...
    </regstate>

  rule <k>
        execinstr (cpuid:Opcode .Operands) 
        =>
        //Super simplified
        writeCpuIdRes(mi(32, 0), // false for now 
                      concatenateMInt(mi(31, 0), M),// false for now
                      mi(32, 0),
                      mi(32, 0))
        ...
    </k>
    <supportedextendedfeatures> ... "FSGSBASE" |-> M ... </supportedextendedfeatures>
    <regstate> RSMap:Map </regstate>
    requires (uvalueMInt(getRegisterValue(%rax, RSMap)) ==Int 7) andBool
             (uvalueMInt(getRegisterValue(%rcx, RSMap)) ==Int 0)

  rule <k>
    execinstr (cpuid:Opcode .Operands) 
    =>
    //EAX has max extended function leaf supported,
    //EBX, ECX, EDX slots are reserved
    writeCpuIdRes(M, 
                  mi(32, 0),
                  mi(32, 0),
                  mi(32, 0))
    ...
    </k>
    <maxextendedleaf> M:MInt </maxextendedleaf> //0x80000007
    <regstate>
        ... "RAX" |-> mi(64, 1 <<Int 31) ...
    </regstate>

  rule <k>
    execinstr (cpuid:Opcode .Operands) 
    =>
    //EAX has processor signature
    //EBX, ECX, EDX have various flags
    writeCpuIdRes(getProcessorSignature(SigMap), 
                  mi(32, 0),
                  concatenateMInts(
                    mi(23,0)
                    {FunMap["PREFETCHW"]}:>MInt
                    mi(2,0)
                    {FunMap["LZCNT"]}:>MInt
                    mi(4,0)
                    {FunMap["LAHF64"]}:>MInt
                  ),
                  concatenateMInts(
                    mi(2,0)
                    {FunMap["64MODEAv"]}:>MInt
                    mi(1,0)
                    {FunMap["RDTSCP"]}:>MInt
                    {FunMap["1GBAv"]}:>MInt
                    mi(5,0)
                    {FunMap["EDB"]}:>MInt
                    mi(8,0)
                    {FunMap["SYSCALL"]}:>MInt
                    mi(11,0)
                  ))
    ...
    </k>
    <processorsignature>
        SigMap
    </processorsignature>
    <extendedfunctioninfo>
        FunMap
    </extendedfunctioninfo>
    <regstate>
        ... "RAX" |-> mi(64, (1 <<Int 31) |Int 1) ...
    </regstate>

  rule <k>
    execinstr (cpuid:Opcode .Operands) 
    =>
    writeCpuIdRes(
      mi(32,0),
      mi(32,0),
      mi(32,0),
      concatenateMInts(mi(23,0) M mi(8,0))
    )
    ...
    </k>
    <supportedextendedfeatures>
        ... "INV_TSC" |-> M ...
    </supportedextendedfeatures>
    <regstate>
        ... "RAX" |-> mi(64, (1 <<Int 31) |Int 7) ...
    </regstate>

  rule <k>
    writeCpuIdRes(M_EAX:MInt, M_EBX:MInt, M_ECX:MInt, M_EDX:MInt) =>
    setRegisterValue(M_EAX, %eax) ~>
    setRegisterValue(M_EBX, %ebx) ~>
    setRegisterValue(M_ECX, %ecx) ~>
    setRegisterValue(M_EDX, %edx) 
    ...
    </k>

endmodule