requires "x86-configuration.k"

module X86-CPUID

  imports X86-CONFIGURATION

  syntax KItem ::= writeCpuIdRes(/* EAX */MInt, 
                                 /* EBX */MInt, 
                                 /* ECX */MInt, 
                                 /* EDX */MInt)

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
    //EAX has max extended function leaf supported,
    //EBX, ECX, EDX spell are reserved
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