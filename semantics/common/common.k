requires "verification-lemmas.k"
requires "common-configuration.k"
requires "common-memory.k"
requires "common-utils.k"
requires "common-error.k"

module COMMON
  imports COMMON-CONFIGURATION
  imports VERIFICATION-LEMMAS
  imports COMMON-MEMORY
  imports COMMON-UTILS

  // Needed by keq
  syntax Bool ::= vars(List)
endmodule
