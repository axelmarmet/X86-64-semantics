require "x86-configuration.k"
require "x86-mint-wrapper.k"
require "x86-abstract-syntax.k"

module X86-MEMORY-SORT
  syntax MemLoadValue
endmodule

module X86-MEMORY-SYNTAX
  imports X86-MEMORY-SORT
  imports X86-ABSTRACT-SORTS
  imports MINT-WRAPPER-SORT
  imports MINT
  imports INT

  syntax Int ::= "StackSpaceForEnvs"

  /*@
    Load Return Value Sort
  */
  syntax MemLoadValue ::= memLoadValue ( MInt )

  syntax Bool ::= isAddressAlignedAt(
                    /* alignment requirement in bits */ Int,
                    /* Address */ MInt) [function]

  /*@
    Load memory at Address represented by MInt for Int bits
  */
  syntax KItem ::=  loadFromMemory(
                      /* Address */ MInt,
                      /* Load size in bits */ Int)

  /*@
    Load memory at Address represented by MInt for Int bits read bytes accross
  */
  syntax KItem ::=  loadFromMemoryWithoutTranslation(
                      /* Address */ MInt,
                      /* Load size in bits */ Int) [strict]

  syntax MInt ::= loadByte(MInt)       [strict] //8  bits
  syntax MInt ::= loadWord(MInt)       [strict] //16 bits
  syntax MInt ::= loadDoubleWord(MInt) [strict] //32 bits
  syntax MInt ::= loadQuadWord(MInt)   [strict] //64 bits
  /*@
    Sorts to be stored in memory.
  */  
  syntax StoreVal ::= MInt | MIntMap

  /*@
    Store 'Val' in 'Nbits' of memory starting at address 'AddrMI'
  */
  syntax KItem ::=  storeToMemory(
                      /* Data */ StoreVal,
                      /* Address */ MInt,
                      /* Store size in bits*/ Int)

  syntax KItem ::=  storeToMemoryAcross(
                      /* Data */ StoreVal,
                      /* Address */ MInt,
                      /* Store size in bits*/ Int)

endmodule


module X86-MEMORY
  imports COMMON-MEMORY-OPAQUE-SYNTAX
  imports COMMON-MEMORY-SYNTAX
  imports X86-CONFIGURATION


  rule StackSpaceForEnvs => 8 [macro]

  /// Decomposition of a dynamic value into bytes
  syntax ByteVal ::= byte(/* position, 0 being the LSB */ Int, MInt)

  // AbstractValue sort defintion for x86 semantics
  syntax AbstractValue ::= ByteVal
  rule getDefaultAbstractValue() => byte(0, undefMInt8)

  // x86 memory helper API implementation for allocation and store.


  /*@
    Create a MemValue out of a storeVal of size Nbits
  */
  syntax MemValue ::= toMemValue(StoreVal, Int)  [function]
  rule toMemValue(V:StoreVal, N:Int) => mList(N /Int 8, 8, toMemData(V, N, .MemData))

  /*@
    Create a MemData out of a storeVal of size Nbits
  */
  syntax MemData ::= toMemData(StoreVal, Int, MemData)  [function, klabel(toMemDataMInt)]

  /*@
    MInt -> MemData
  */
  rule toMemData(V:MInt, N:Int, Bytes:MemData) => toMemDataFromMInt(V, N, Bytes)
    requires bitwidthMInt(V) ==Int N 

  syntax MemData ::= toMemDataFromMInt(MInt, Int, MemData) [function]
  rule toMemDataFromMInt(MI:MInt, N:Int, Bytes:MemData) => appendMemData(Bytes, toBytes(N, MI))

  /*@
    MIntMap -> MemData
  */
  rule toMemData(mimap(M):MIntMap, N:Int, Bytes:MemData) => toMemDataFromMIntMap(M, 0, size(M), Bytes)
    requires bitwidthMInt({M[0]}:>MInt) *Int size(M) ==Int N 

  syntax MemData ::= toMemDataFromMIntMap(Map, Int, Int, MemData) [function]

  rule toMemDataFromMIntMap(_:Map, N:Int, N, Bytes:MemData) => Bytes
  rule toMemDataFromMIntMap(M:Map, I:Int, N:Int, Bytes:MemData) =>
        toMemDataFromMIntMap(M, I +Int 1, N, toMemData({M[I]}:>MInt, bitwidthMInt({M[I]}:>MInt), Bytes))
    requires I <Int N

  /*@
    toBytes(N:Int, MI:MInt)
    Convert MI to 
      List{ byte(0, MI)  byte(1, MI) ... byte(M-1, MI) } where M = N / 8
  */  
  syntax MemData ::= toBytes(Int, MInt) [function]
  rule toBytes(N:Int, MI:MInt) => toBytesAux(N /Int 8, MI, .MemData)

  syntax MemData ::= toBytesAux(Int, MInt, /* bytes accumulator */ MemData) [function]
  rule toBytesAux(0 , _:MInt, Bytes:MemData) => Bytes
  rule toBytesAux(N:Int, MI:MInt, Bytes:MemData)
       =>
       toBytesAux(N -Int 1, MI, byte(N -Int 1, MI) Bytes)
    requires N >Int 0


  // x86 memory helper API implementation for load.
  syntax KItem ::= fromMemValue(KItem, Int) [strict(1)]
  rule fromMemValue(mList(_:Int, 8, Bytes:MemData), N:Int) => 
   memLoadValue ( fromBytes(takeMemData(N /Int 8, Bytes)) )

  syntax KItem ::= fromMemValueBigEndian(KItem, Int) [strict(1)]
  rule fromMemValueBigEndian(mList(_:Int, 8, Bytes:MemData), N:Int) => 
   memLoadValue ( fromBytesBigEndian(takeMemData(N /Int 8, Bytes)) )


  syntax MInt ::= fromBytes(MemData) [function]
  rule fromBytes(byte(I:Int, MI:MInt) Rest) =>  extractMask(MI, 8, I *Int 8)
    requires Rest ==K .MemData
  rule fromBytes(byte(I:Int, MI:MInt) Rest:MemData) =>  concatenateMInt(fromBytes(Rest), extractMask(MI, 8, I *Int 8))
    requires Rest =/=K .MemData

  syntax MInt ::= fromBytesBigEndian(MemData) [function]
  rule fromBytesBigEndian(byte(I:Int, MI:MInt) Rest) =>  extractMask(MI, 8, I *Int 8)
    requires Rest ==K .MemData
  rule fromBytesBigEndian(byte(I:Int, MI:MInt) Rest:MemData) =>  concatenateMInt(extractMask(MI, 8, I *Int 8), fromBytesBigEndian(Rest))
    requires Rest =/=K .MemData
  // x86 memory API implementation

  /*@
    Load memory Nbits:Int bits from Address represented AddrMI:MInt
  */
  rule <k>
    //loadFromMemory(AddrMI:MInt, Nbits:Int) =>
    loadFromMemory(ptr(L:MemLoc, AddrMI:MInt), Nbits:Int) =>
      fromMemValue(mRead(L, uvalueMInt(AddrMI) *Int 8, Nbits /Int 8, 8), Nbits)
  ... </k>
    //<stackbase> stackBaseInfo( L:MemLoc, _:K) </stackbase>
      requires Nbits %Int 8 ==Int 0

  /*@
    Load memory Nbits:Int bits from Address represented AddrMI:MInt
  */
  //context loadFromMemory(HOLE:MInt, N:Int) [result(PhysicalAddress)]
  rule 
    <k>
    loadFromMemory(AddrMI:MInt, Nbits:Int) => 
      loadFromMemoryWithoutTranslation(AddrMI, Nbits) ...
    </k>
    //<stackbase> stackBaseInfo( L:MemLoc, _:K) </stackbase>
      requires Nbits %Int 8 ==Int 0

  rule <k>
    loadByte(AddrMI:MInt) => 
    loadFromMemoryWithoutTranslation(AddrMI, 8) ...
  </k>
  rule <k>
    loadWord(AddrMI:MInt) =>    
    loadFromMemoryWithoutTranslation(AddrMI, 16) ...
  </k>
  
  rule <k>
    loadDoubleWord(AddrMI:MInt) => 
    loadFromMemoryWithoutTranslation(AddrMI, 32) ...
  </k>
  rule <k>
    loadQuadWord(AddrMI:MInt) => 
    loadFromMemoryWithoutTranslation(AddrMI, 64) ...
  </k>

  rule 
    <k>
    loadFromMemoryWithoutTranslation(AddrMI:MInt, Nbits:Int) =>
      fromMemValueBigEndian(
        mReadAcross(
          loc(
            uvalueMInt(AddrMI),
            1,
            8,
            0
          ), Nbits /Int 8),
        Nbits)
    ... 
    </k>
    //<stackbase> stackBaseInfo( L:MemLoc, _:K) </stackbase>
      requires Nbits %Int 8 ==Int 0

  /*@
    Store 'Val' in 'Nbits' of memory starting at address 'AddrMI'
  */
  rule <k>
    //storeToMemory(Val:StoreVal, AddrMI:MInt, Nbits:Int) => mWrite(L, uvalueMInt(AddrMI) *Int 8, toMemValue(Val, Nbits))
    storeToMemory(Val:StoreVal, ptr(L:MemLoc, AddrMI:MInt), Nbits:Int) => mWrite(L, uvalueMInt(AddrMI) *Int 8, toMemValue(Val, Nbits))
  ... </k>
    //<stackbase> stackBaseInfo( L:MemLoc, _:K) </stackbase>
      requires Nbits %Int 8 ==Int 0


  rule <k>
    storeToMemoryAcross(Val:StoreVal, Addr:MInt, NBits:Int) => 
    mWriteAcross(
      loc(
        uvalueMInt(Addr),
        1,
        8,
        0
      ),
      toMemValue(Val, NBits)
    )
  ... </k>
    //<stackbase> stackBaseInfo( L:MemLoc, _:K) </stackbase>
      requires NBits %Int 8 ==Int 0
endmodule
