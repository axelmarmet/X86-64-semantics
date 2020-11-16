module COMMON-UTILS-SYNTAX
  imports INT
  imports MAP
  imports MINT

  syntax Map ::= Int ".." Int "|->" K [function]
  syntax MInt ::= updateExceptMask(MInt /* old */, 
                                   MInt /* new */, 
                                   MInt /* mask */) [function]

  syntax Int ::= fromBool(Bool) [function]
endmodule


module COMMON-UTILS
  imports COMMON-UTILS-SYNTAX

  rule N:Int .. M:Int |-> _:K => .Map
    requires N >Int M
  rule N:Int .. M:Int |-> V:KItem => N |-> V (N +Int 1) .. M |-> V
    requires N <=Int M

  rule updateExceptMask(Old:MInt, New:MInt, Mask:MInt) =>
    orMInt(
      andMInt(
        Old,
        Mask
      ),
      andMInt(
        New,
        negMInt(Mask)
      )
    )

  rule fromBool(B:Bool) => #if B #then 1 #else 0 #fi
endmodule
