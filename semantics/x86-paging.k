require "x86-syntax.k"

module X86-PAGING-SYNTAX

  imports X86-SYNTAX

  syntax PML4Entry ::= MInt //PML4 = Page-Map Level 4
  syntax PDPTEntry ::= MInt //PDPT = Page-Directory-Pointer Table
  syntax PDEntry   ::= MInt //PD   = Page-Directory 
  syntax PTEntry   ::= MInt //PT   = Page Table

  syntax MInt      ::= load(MInt) [function]
  syntax Int       ::= read(Int) [function]
  // the entries that can directly reference a physical memory location 
  // instead of another page table entry
  syntax LowerPagesEntry ::= PDPTEntry | PDEntry | PTEntry 


  syntax VirtualAddress    ::= MInt
  syntax PhysicalAddress   ::= MInt

  syntax PhysicalAddress ::= translateAddress(VirtualAddress) [function]

endmodule

module X86-PAGING

endmodule