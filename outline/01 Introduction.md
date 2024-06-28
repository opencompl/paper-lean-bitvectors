# Introduction

 * Bitvectors are foundational to low-level reasoning (e.g., LLVM IR, crypto, hardware)
 * SMT-solvers are good at solving bounded problems, at low bounds at least
 * However, crypto sometimes wants to talk about bitvectors with bounds too large
 * Also, since SMT-solvers basically solve the problem for each concrete width within the bound, they scale really poorly when a problem involves multiple, independent widths.
 
 For this reason, we look into solving bitvector problems for arbitrary/unbounded widths:
 * This problem is known to be undecidable in general
 * Yet, we can recognize specific classes of bitvectors problems that *do* have a decision procedure.
 * We identify three such clasess, depending on the operations that are contained in the expression:
	 * Only bitwise operations (and, or, not, xor)
	 * Only addition and multiplication
	 * Only addition, bitwise operations, left shift by a constant


We've implemented these decision procedures in Lean 
>[!TODO]
> - Introduce Lean
> - Defend why we use Lean

Furthermore, we evaluate these decision procedures by looking at a big corpus of real-world bitvector equalities, taken from the domain of compiler optimizations, to see what portion of real-world problems fall within the classes we are able to solve.



