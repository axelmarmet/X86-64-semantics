require "x86-syntax.k"

module X86-PAGING-SYNTAX

  imports X86-SYNTAX

  syntax PML4Entry ::= pml4Entry(MInt) //PML4 = Page-Map Level 4
  syntax PDPTEntry ::= pdptEntry(MInt) //PDPT = Page-Directory-Pointer Table

  syntax PhysAddress ::= physAddr(MInt)
  syntax VirtAddress ::= virtAddr(MInt)

  syntax MemAddress ::= PhysAddress
  syntax MemAddress ::= VirtAddress
  syntax MemAddress ::= MInt
  syntax MemAddress ::= translateAddress(MemAddress)

  syntax PML4Entry ::= loadPML4Entry(MInt, MInt) [strict] 
  syntax PDPTEntry ::= loadPDPTEntry(PML4Entry, MInt) [strict]
  syntax KItem ::= getPhysicalAddress(MInt)

endmodule

module X86-PAGING
  imports X86-MEMORY
  imports X86-ABSTRACT-SEMANTICS
  imports X86-PAGING-SYNTAX

  //helper to extract MemLoadValue
  syntax MInt ::= extractMemLoadValue(KItem) [function]
  rule extractMemLoadValue(memLoadValue(M:MInt):MemLoadValue) => M

  syntax Bool ::= isIA32EFERLMESet(Map) [function]
  rule isIA32EFERLMESet(RSMap:Map) => eqMInt(mi(1,1), extractMask({RSMap["IA32_EFER"]}:>MInt, 1, 8))

  syntax Bool ::= isPGSet(Map) [function]
  rule isPGSet(RSMap:Map) => eqMInt(mi(1,1), {RSMap["PG"]}:>MInt)           

  syntax Bool ::= isPAESet(Map) [function]
  rule isPAESet(RSMap:Map) => eqMInt(mi(1,1), {RSMap["PAE"]}:>MInt)

  syntax Bool ::= pagingEnabled(Map) [function]
  rule pagingEnabled(RSMap:Map) => isIA32EFERLMESet(RSMap) andBool isPAESet(RSMap) andBool isPGSet(RSMap)
    

  rule <k> translateAddress(virtAddr(Addr:MInt)) =>
     loadPDPTEntry(loadPML4Entry({RSMap["PageDirectoryBase"]}:>MInt, Addr), Addr) ~> getPhysicalAddress(Addr) ...
   </k>
   <regstate> RSMap </regstate>
   requires pagingEnabled(RSMap)

  rule <k> translateAddress(virtAddr(Addr:MInt)) =>
      translateAddress(physAddr(Addr)) ...
    </k>
    <regstate> RSMap </regstate>
    requires notBool pagingEnabled(RSMap)

  rule translateAddress(MI:MInt) => translateAddress(virtAddr(MI))

  rule <k>
      loadPML4Entry(Base:MInt, VirtAddr:MInt) => 
        pml4Entry(
          extractMemLoadValue(
            loadQuadWord
              (concatenateMInts(
                Base 
                extractMask(VirtAddr, 9, 39) 
                mi(3, 0) 
                .MInts)))) ...
    </k>

  rule <k>
      loadPDPTEntry(Entry:PML4Entry, VirtAddr:MInt) => 
        pdptEntry(
          extractMemLoadValue(
            loadQuadWord(
              concatenateMInts(
                extractBaseFromPML4Entry(Entry) 
                extractMask(VirtAddr, 9, 30)  
                mi(3, 0) 
                .MInts)))) ...
    </k>

  rule <k> Entry:PDPTEntry ~> getPhysicalAddress(VirtAddr:MInt) => 
      translateAddress(physAddr(concatenateMInts(
        extractPhysicalAddressFromPDPTEntry(Entry)
        extractMask(VirtAddr, 30, 0))))
    </k>
    requires eqMInt(pageSizeBit(Entry), mi(1,1))

  //helpers
  syntax MInt ::= extractBaseFromPML4Entry(PML4Entry)
  syntax MInt ::= extractPhysicalAddressFromPDPTEntry(PDPTEntry)
  syntax MInt ::= pageSizeBit(PDPTEntry)

  rule extractBaseFromPML4Entry(pml4Entry(M:MInt):PML4Entry) => extractMask(M, 40, 12) [macro]
  rule extractPhysicalAddressFromPDPTEntry(pdptEntry(M:MInt):PDPTEntry) => extractMask(M, 22, 30) [macro]
  rule pageSizeBit(pdptEntry(M:MInt):PDPTEntry) => extractMask(M, 1, 7) [macro]

endmodule