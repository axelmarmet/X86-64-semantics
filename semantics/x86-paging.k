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
  syntax PDPTEntry ::= loadPDPTEntry(MInt) 
  syntax KItem ::= getPhysicalAddress(MInt)

endmodule

module X86-PAGING
  imports X86-MEMORY
  imports X86-ABSTRACT-SEMANTICS
  imports X86-PAGING-SYNTAX

  rule <k> translateAddress(virtAddr(Addr:MInt)) =>
     loadPML4Entry({RSMap["PageDirectoryBase"]}:>MInt, Addr) ~> loadPDPTEntry(Addr) ~> getPhysicalAddress(Addr) ...
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
        loadFromMemoryWithoutTranslation(
          (concatenateMInts(
            Base 
            extractMask(VirtAddr, 9, 39) 
            mi(3, 0) 
            .MInts)),
          64) ~> loadPML4Entry(Base, VirtAddr) ...
    </k>

    rule <k>
      memLoadValue(Res:MInt):MemLoadValue ~> loadPML4Entry(_:MInt, _:MInt) => 
        pml4Entry(Res) ...
    </k>

  rule <k>
      pml4Entry(Entry:MInt):PML4Entry ~> loadPDPTEntry(VirtAddr:MInt) => 
            loadFromMemoryWithoutTranslation(
              concatenateMInts(
                extractBaseFromPML4Entry(pml4Entry(Entry)) 
                extractMask(VirtAddr, 9, 30)  
                mi(3, 0) 
                .MInts),
              64) ~> loadPDPTEntry(VirtAddr) ...
    </k>

    rule <k>
      memLoadValue(Res:MInt):MemLoadValue ~> loadPDPTEntry(VirtAddr:MInt) => 
          pdptEntry(Res) ...
    </k>

  rule <k> Entry:PDPTEntry ~> getPhysicalAddress(VirtAddr:MInt) => 
      translateAddress(physAddr(concatenateMInts(
        extractPhysicalAddressFromPDPTEntry(Entry)
        extractMask(VirtAddr, 30, 0)))) ...
    </k>
    requires eqMInt(pageSizeBit(Entry), mi(1,1))

  //helpers
  syntax MInt ::= extractBaseFromPML4Entry(PML4Entry) [function]
  syntax MInt ::= extractPhysicalAddressFromPDPTEntry(PDPTEntry) [function]
  syntax MInt ::= pageSizeBit(PDPTEntry) [function]

  rule extractBaseFromPML4Entry(pml4Entry(M:MInt):PML4Entry) => extractMask(M, 40, 12) 
  rule extractPhysicalAddressFromPDPTEntry(pdptEntry(M:MInt):PDPTEntry) => extractMask(M, 22, 30) 
  rule pageSizeBit(pdptEntry(M:MInt):PDPTEntry) => extractMask(M, 1, 7) 

endmodule