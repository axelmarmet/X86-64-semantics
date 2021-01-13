requires "x86-configuration.k"

module X86-LOADER-SYNTAX
  imports MINT

  syntax KItem ::= "loadEntryPoint" 

endmodule

module X86-LOADER
  imports X86-ABSTRACT-SEMANTICS
  imports X86-LOADER-SYNTAX
  imports X86-CONFIGURATION
  imports MINT-WRAPPER-SYNTAX
  imports ID

  /*@
    Unroll intructions into KList.
  */
  rule I:Instruction Is:Instructions => I ~> Is

  /*@
    Unroll lines into KList.
  */
  rule L:Line Ls:Lines => L ~> Ls

  /*@
    Ignore certain contructs for the time being.
  */
  rule <k> .section .rodata  => . ...</k>
    <currentsection> _ => "rodata" </currentsection>

  rule <k> .data   => . ...</k>
    <currentsection> _ => "data" </currentsection>

  rule <k> .bss   => . ...</k>
    <currentsection> _ => "bss" </currentsection>

  rule <k> .text   => . ...</k>
    <currentsection> _ => "text" </currentsection>

  rule <k> .globl G:X86Id  => . ...</k>
  rule <k> .file _:String  => . ...</k>

  /*@
    Populate  data section
  */
  // .comm
  rule <k> .comm LabelId:X86Id, I:Int, _:Int  =>  
    storeToMemory(
        mi(I *Int 8, 0),
        ptr(L, NextOffset), 
        I *Int 8)
  ...</k>
    <functargets> FMap:Map => FMap[ LabelId <- ptr(L, NextOffset)] </functargets>
    <database> 
      dataBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, I))) 
    </database>
      requires I >=Int 0

  /*@
    Populate current section
  */

  // .zero I in .bss section
  rule <k> .zero I:Int  =>  
    storeToMemory(
        mi(I *Int 8 , 0),
        ptr(L, NextOffset), 
       I *Int 8)
  ...</k>
    <functargets> FMap:Map => FMap[LabelId <- ptr(L, NextOffset)] </functargets>
    <bsstargets> BSSMap:Map => BSSMap[LabelId <- ptr(L, NextOffset)] </bsstargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <bssbase> 
      bssBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, I))) 
    </bssbase>
    <currentsection> SectionName:String </currentsection>
      requires notBool LabelId in_keys (BSSMap) andBool SectionName ==String "bss"

  rule <k> .zero I:Int  =>  
    storeToMemory(
        mi(I *Int 8 , 0),
        ptr(L, NextOffset), 
       I *Int 8)
  ...</k>
    <bsstargets> BSSMap:Map </bsstargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <bssbase> 
      bssBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, I))) 
    </bssbase>
    <currentsection> SectionName:String </currentsection>
      requires  LabelId in_keys (BSSMap) andBool SectionName ==String "bss"    

  // .zero I in .data section
  rule <k> .zero I:Int  =>  
    storeToMemory(
        mi(I *Int 8 , 0),
        ptr(L, NextOffset), 
       I *Int 8)
  ...</k>
    <functargets> FMap:Map => FMap[LabelId <- ptr(L, NextOffset)] </functargets>
    <datatargets> DMap:Map => DMap[LabelId <- ptr(L, NextOffset)] </datatargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <database> 
      dataBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, I))) 
    </database>
    <currentsection> SectionName:String </currentsection>
      requires notBool LabelId in_keys (DMap) andBool SectionName ==String "data"

  rule <k> .zero I:Int  =>  
    storeToMemory(
        mi(I *Int 8 , 0),
        ptr(L, NextOffset), 
       I *Int 8)
  ...</k>
    <datatargets> DMap:Map </datatargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <database> 
      dataBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, I))) 
    </database>
    <currentsection> SectionName:String </currentsection>
      requires  LabelId in_keys (DMap) andBool SectionName ==String "data"    

  // .zero I in .rodata section
  rule <k> .zero I:Int  =>  
    storeToMemory(
        mi(I *Int 8 , 0),
        ptr(L, NextOffset), 
       I *Int 8)
  ...</k>
    <functargets> FMap:Map => FMap[LabelId <- ptr(L, NextOffset)] </functargets>
    <rotargets> ROMap:Map => ROMap[LabelId <- ptr(L, NextOffset)] </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, I))) 
    </robase>
    <currentsection> SectionName:String </currentsection>
      requires notBool LabelId in_keys (ROMap) andBool SectionName ==String "rodata"

  rule <k> .zero I:Int  =>  
    storeToMemory(
        mi(I *Int 8 , 0),
        ptr(L, NextOffset), 
       I *Int 8)
  ...</k>
    <rotargets> ROMap:Map </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, I))) 
    </robase>
    <currentsection> SectionName:String </currentsection>
      requires  LabelId in_keys (ROMap) andBool SectionName ==String "rodata"    


  // .quad in .rodata section
  // .quad I
  rule <k> .quad I:Int  =>  
    storeToMemory(
        mi(64, I),
        ptr(L, NextOffset), 
        64)
  ...</k>
    <functargets> FMap:Map => FMap[LabelId <- ptr(L, NextOffset)] </functargets>
    <rotargets> ROMap:Map => ROMap[LabelId <- ptr(L, NextOffset)] </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 8))) 
    </robase>
    <currentsection> SectionName:String </currentsection>
      requires notBool LabelId in_keys (ROMap) andBool SectionName ==String "rodata" andBool SectionName =/=String "bss"

  rule <k> .quad I:Int  =>  
    storeToMemory(
        mi(64, I),
        ptr(L, NextOffset), 
        64)
  ...</k>
    <rotargets> ROMap:Map  </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 8))) 
    </robase>
    <currentsection> SectionName:String </currentsection>
      requires  LabelId in_keys (ROMap) andBool SectionName ==String "rodata" andBool SectionName =/=String "bss"

  // .quad L + I
  rule <k> .quad LName:X86Id   => .quad LName:X86Id + 0
  ...</k>

  rule <k> .quad LName:X86Id + I:Int  =>  
    storeToMemory(
        addMInt({FMap[LName]}:>PointerVal, mi(64, I)),
        ptr(L, NextOffset), 
        64)
  ...</k>
    <functargets> FMap:Map => FMap[LabelId <- ptr(L, NextOffset)] </functargets>
    <rotargets> ROMap:Map => ROMap[LabelId <- ptr(L, NextOffset)] </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 8))) 
    </robase>
    <currentsection> SectionName:String </currentsection>
      requires (notBool LabelId in_keys (ROMap)) 
              andBool SectionName ==String "rodata" 
              andBool SectionName =/=String "bss"
              andBool LName in_keys (FMap)

  rule <k> .quad LName:X86Id + I:Int  =>  
    storeToMemory(
        addMInt({FMap[LName]}:>PointerVal, mi(64, I)),
        ptr(L, NextOffset), 
        64)
  ...</k>
    <functargets> FMap:Map </functargets>
    <rotargets> ROMap:Map  </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 8))) 
    </robase>
    <currentsection> SectionName:String </currentsection>
      requires  LabelId in_keys (ROMap) 
                andBool SectionName ==String "rodata" 
                andBool SectionName =/=String "bss"
                andBool LName in_keys (FMap)


  // .quad  in .data section
  // .quad I    
  rule <k> .quad I:Int  =>  
    storeToMemory(
        mi(64, I),
        ptr(L, NextOffset), 
        64)
  ...</k>
    <functargets> FMap:Map => FMap[LabelId <- ptr(L, NextOffset)] </functargets>
    <datatargets> DMap:Map => DMap[LabelId <- ptr(L, NextOffset)] </datatargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <database> 
      dataBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 8))) 
    </database>
    <currentsection> SectionName:String </currentsection>
      requires notBool LabelId in_keys (DMap) andBool SectionName ==String "data" andBool SectionName =/=String "bss"

  rule <k> .quad I:Int  =>  
    storeToMemory(
        mi(64, I),
        ptr(L, NextOffset), 
        64)
  ...</k>
    <datatargets> DMap:Map  </datatargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <database> 
      dataBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 8))) 
    </database>
    <currentsection> SectionName:String </currentsection>
      requires  LabelId in_keys (DMap) andBool SectionName ==String "data" andBool SectionName =/=String "bss"

  // .quad L + I
  rule <k> .quad LName:X86Id + I:Int  =>  
    storeToMemory(
        addMInt({FMap[LName]}:>PointerVal, mi(64, I)),
        ptr(L, NextOffset), 
        64)
  ...</k>
    <functargets> FMap:Map => FMap[LabelId <- ptr(L, NextOffset)] </functargets>
    <datatargets> DMap:Map => DMap[LabelId <- ptr(L, NextOffset)] </datatargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <database> 
      dataBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 8))) 
    </database>
    <currentsection> SectionName:String </currentsection>
      requires (notBool LabelId in_keys (DMap)) 
                andBool SectionName ==String "data" 
                andBool SectionName =/=String "bss"
                andBool LName in_keys (FMap)

  rule <k> .quad LName:X86Id + I:Int  =>  
    storeToMemory(
        addMInt({FMap[LName]}:>PointerVal, mi(64, I)),
        ptr(L, NextOffset), 
        64)
  ...</k>
    <functargets> FMap:Map </functargets>
    <datatargets> DMap:Map  </datatargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <database> 
      dataBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 8))) 
    </database>
    <currentsection> SectionName:String </currentsection>
      requires  LabelId in_keys (DMap) 
                andBool SectionName ==String "data" 
                andBool SectionName =/=String "bss"
                andBool LName in_keys (FMap)

  // .long I in .rodata section
  rule <k> .long I:Int  =>  
    storeToMemory(
        mi(32,I),
        ptr(L, NextOffset), 
        32)
  ...</k>
    <functargets> FMap:Map => FMap[LabelId <- ptr(L, NextOffset)] </functargets>
    <rotargets> ROMap:Map => ROMap[LabelId <- ptr(L, NextOffset)] </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 4))) 
    </robase>
    <currentsection> SectionName:String </currentsection>
      requires notBool LabelId in_keys (ROMap) andBool SectionName ==String "rodata" andBool SectionName =/=String "bss"

  rule <k> .long I:Int  =>  
    storeToMemory(
        mi(32,I),
        ptr(L, NextOffset), 
        32)
  ...</k>
    <rotargets> ROMap:Map  </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 4))) 
    </robase>
    <currentsection> SectionName:String </currentsection>
      requires  LabelId in_keys (ROMap) andBool SectionName ==String "rodata" andBool SectionName =/=String "bss"

  // .long I in .data section
  rule <k> .long I:Int  =>  
    storeToMemory(
        mi(32,I),
        ptr(L, NextOffset), 
        32)
  ...</k>
    <functargets> FMap:Map => FMap[LabelId <- ptr(L, NextOffset)] </functargets>
    <datatargets> DMap:Map => DMap[LabelId <- ptr(L, NextOffset)] </datatargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <database> 
      dataBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 4))) 
    </database>
    <currentsection> SectionName:String </currentsection>
      requires notBool LabelId in_keys (DMap) andBool SectionName ==String "data" andBool SectionName =/=String "bss"

  rule <k> .long I:Int  =>  
    storeToMemory(
        mi(32,I),
        ptr(L, NextOffset), 
        32)
  ...</k>
    <datatargets> DMap:Map  </datatargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <database> 
      dataBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 4))) 
    </database>
    <currentsection> SectionName:String </currentsection>
      requires  LabelId in_keys (DMap) andBool SectionName ==String "data" andBool SectionName =/=String "bss"


  // .byte I in .rodata section
  rule <k> .byte I:Int  =>  
    storeToMemory(
        mi(8,I),
        ptr(L, NextOffset), 
        8)
  ...</k>
    <functargets> FMap:Map => FMap[LabelId <- ptr(L, NextOffset)] </functargets>
    <rotargets> ROMap:Map => ROMap[LabelId <- ptr(L, NextOffset)] </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 1))) 
    </robase>
    <currentsection> SectionName:String </currentsection>
      requires notBool LabelId in_keys (ROMap) andBool SectionName ==String "rodata" andBool SectionName =/=String "bss"

  rule <k> .byte I:Int  =>  
    storeToMemory(
        mi(8,I),
        ptr(L, NextOffset), 
        8)
  ...</k>
    <rotargets> ROMap:Map  </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 1))) 
    </robase>
    <currentsection> SectionName:String </currentsection>
      requires  LabelId in_keys (ROMap) andBool SectionName ==String "rodata" andBool SectionName =/=String "bss"

  // .byte I in .data section
  rule <k> .byte I:Int  =>  
    storeToMemory(
        mi(8,I),
        ptr(L, NextOffset), 
        8)
  ...</k>
    <functargets> FMap:Map => FMap[LabelId <- ptr(L, NextOffset)] </functargets>
    <datatargets> DMap:Map => DMap[LabelId <- ptr(L, NextOffset)] </datatargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <database> 
      dataBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 1))) 
    </database>
    <currentsection> SectionName:String </currentsection>
      requires notBool LabelId in_keys (DMap) andBool SectionName ==String "data" andBool SectionName =/=String "bss"

  rule <k> .byte I:Int  =>  
    storeToMemory(
        mi(8,I),
        ptr(L, NextOffset), 
        8)
  ...</k>
    <datatargets> DMap:Map  </datatargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <database> 
      dataBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 1))) 
    </database>
    <currentsection> SectionName:String </currentsection>
      requires  LabelId in_keys (DMap) andBool SectionName ==String "data" andBool SectionName =/=String "bss"

  // .value I in .rodata section
  rule <k> .value I:Int  =>  
    storeToMemory(
        mi(16,I),
        ptr(L, NextOffset), 
        16)
  ...</k>
    <functargets> FMap:Map => FMap[LabelId <- ptr(L, NextOffset)] </functargets>
    <rotargets> ROMap:Map => ROMap[LabelId <- ptr(L, NextOffset)] </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 2))) 
    </robase>
    <currentsection> SectionName:String </currentsection>
      requires notBool LabelId in_keys (ROMap) andBool SectionName ==String "rodata" andBool SectionName =/=String "bss"

  rule <k> .value I:Int  =>  
    storeToMemory(
        mi(16,I),
        ptr(L, NextOffset), 
        16)
  ...</k>
    <rotargets> ROMap:Map  </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 2))) 
    </robase>
    <currentsection> SectionName:String </currentsection>
      requires  LabelId in_keys (ROMap) andBool SectionName ==String "rodata" andBool SectionName =/=String "bss"

  // .value I in .data section
  rule <k> .value I:Int  =>  
    storeToMemory(
        mi(16,I),
        ptr(L, NextOffset), 
        16)
  ...</k>
    <functargets> FMap:Map => FMap[LabelId <- ptr(L, NextOffset)] </functargets>
    <datatargets> DMap:Map => DMap[LabelId <- ptr(L, NextOffset)] </datatargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <database> 
      dataBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 2))) 
    </database>
    <currentsection> SectionName:String </currentsection>
      requires notBool LabelId in_keys (DMap) andBool SectionName ==String "data" andBool SectionName =/=String "bss"

  rule <k> .value I:Int  =>  
    storeToMemory(
        mi(16,I),
        ptr(L, NextOffset), 
        16)
  ...</k>
    <datatargets> DMap:Map  </datatargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <database> 
      dataBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, 2))) 
    </database>
    <currentsection> SectionName:String </currentsection>
      requires  LabelId in_keys (DMap) andBool SectionName ==String "data" andBool SectionName =/=String "bss"

  /*@
    Populate RO data
  */
  // .string S
  rule <k> .string S:String  =>  
    storeToMemory(
        createMIntMapFromString(S +String "\x00"), 
        ptr(L, NextOffset), 
        (lengthString(S) +Int 1) *Int 8)
  ...</k>
    <functargets> FMap:Map => FMap[LabelId <- ptr(L, NextOffset)] </functargets>
    <rotargets> ROMap:Map => ROMap[LabelId <- ptr(L, NextOffset)] </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, lengthString(S) +Int 1))) 
    </robase>
      requires notBool LabelId in_keys (ROMap)

  rule <k> .string S:String  =>  
    storeToMemory(
        createMIntMapFromString(S +String "\x00"), 
        ptr(L, NextOffset), 
        (lengthString(S) +Int 1) *Int 8)
  ...</k>
    <rotargets> ROMap:Map  </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, lengthString(S) +Int 1))) 
    </robase>
      requires  LabelId in_keys (ROMap)

  // .ascii S
  rule <k> .ascii S:String  =>  
    storeToMemory(
        createMIntMapFromString(S), 
        ptr(L, NextOffset), 
        (lengthString(S)) *Int 8)
  ...</k>
    <functargets> FMap:Map => FMap[LabelId <- ptr(L, NextOffset)] </functargets>
    <rotargets> ROMap:Map => ROMap[LabelId <- ptr(L, NextOffset)] </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, lengthString(S) +Int 1))) 
    </robase>
      requires notBool LabelId in_keys (ROMap)

  rule <k> .ascii S:String  =>  
    storeToMemory(
        createMIntMapFromString(S), 
        ptr(L, NextOffset), 
        (lengthString(S)) *Int 8)
  ...</k>
    <rotargets> ROMap:Map  </rotargets>
    <lastseenlabel> LabelId:X86Id </lastseenlabel>
    <robase> 
      roBaseInfo(
          L:MemLoc, 
          BaseOffset:MInt, 
          NextOffset:MInt => addMInt(NextOffset, mi(addrSize, lengthString(S) +Int 1))) 
    </robase>
      requires  LabelId in_keys (ROMap)
  
  /*@
    Record the PC corresponding to labels. 
  */  
  rule <k> (LabelId:X86Id:):Label => . ...</k>
        <functargets> FMap:Map => FMap[LabelId <- ptr(symloc(-1, 0, 0, 0, 0), L)] </functargets>
        <nextLocPc> L </nextLocPc>
        <lastseenlabel> _:K => LabelId </lastseenlabel>

  syntax String ::= Hex2String ( HexConstant )    [function, hook(STRING.token2string)]
  syntax Int ::= getAsmSize(HexConstant) [function]
  rule getAsmSize(H:HexConstant) => (lengthString(HexConstant2String(H)) -Int 2) /Int 2

  /*@
    Load the instructions into Code memory.
    The reason for parsing instruction as (OpC OpR) is to 
    avoid on instructions like .section ...
  */
  rule  
    <k> 
      (Addr:HexConstant : Asm:HexConstant (OpC:Opcode OpR:Operands):Instruction):Line => 
      mi(64, hexToInt(Addr)) ~> mi(getAsmSize(Asm) *Int 8, hexToInt(Asm)) ~> (OpC OpR) ...
    </k>
    
  rule
    <k>
      Addr:MInt ~> Asm:MInt ~> (OpC:Opcode OpR:Operands):Instruction => 
      storeToMemoryWithoutTranslation(
        Asm,
        Addr,
        bitwidthMInt(Asm)
      ) ...
    </k>
    <sizeHint> hint(M1:Map => M1[Addr <- bitwidthMInt(Asm)]) </sizeHint>
    <text> code(M:Map => M[Asm <- execinstr(OpC OpR)]) </text>


  /*@
    Load data in memory
  */
  rule  
    <k> 
      (Addr:HexConstant : Data:DataBytes ):Line => 
      storeToMemoryWithoutTranslation(
        convertDataBytesToMIntMap(Data),
        mi(64, hexToInt(Addr)),
        dataSize(Data) *Int 8) 
      ...
    </k>
  
  syntax MIntMap ::= convertDataBytesToMIntMap(DataBytes) [function]
  rule convertDataBytesToMIntMap(D:DataBytes) => convertDataBytesToMIntMapAux(D, 0, .Map)

  syntax MIntMap ::= convertDataBytesToMIntMapAux(DataBytes, Int ,Map) [function] 
  rule convertDataBytesToMIntMapAux(.DataBytes, _, M) => mimap(M)
  rule convertDataBytesToMIntMapAux(Head Tail, I, M) => 
    convertDataBytesToMIntMapAux(Tail, I +Int 1, M[I <- mi(8, hexToInt(Head))])

  syntax Int ::= dataSize(DataBytes) [function]
  rule dataSize(.DataBytes) => 0
  rule dataSize(Da Tail) => 1 +Int dataSize(Tail)

  rule  <k>.Lines => .K ...</k>

  /*@
    RIP is set to the entry point address corresponding to labels
    'main' or '_start' in order to begin execution.
  */
  rule  <k> loadEntryPoint => .K ...</k>
        <regstate> RSMap => RSMap["RIP" <- EntryPoint] </regstate>
        <entrypoint> EntryPoint </entrypoint>

endmodule
