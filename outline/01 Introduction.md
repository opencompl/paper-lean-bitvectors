# Introduction

 * Bitvectors are foundational to low-level reasoning (e.g., LLVM IR, crypto, hardware)
 * SMT-solvers are good at solving bounded problems, at low bounds at least
* However, to 

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

Our contributions are:
	* First-class bit vectors for interactive theorem proving: design and implementation of a bitvector theory, its close integration with fixed and arbitrary-width decision procedures, and the deep integration of our system in a modern modern theorem prover -- offering streamlined bit vector reasoning for proof engineering
	* A fully integrated tactic to discharge fixed-width bitvector goals, by using reflection, a verified bitblaster, and SAT certificate checking
	* An automata based verified decision procedure which can solve a mix of arbitrary-width bitwise and arithmetic operations, and use it to build a simplification pass for bitvector goals
	* An overview of existing bitvector decision procedures, proof automation in general, and the bitvector equalities they can solve

>[!TODO]
> De-emphasize the evaluation in the intro: our main contribution is the integration / proof automation; the evaluation is just the cherry on top.

### Related Work
Shi et al. built a verified bitblaster in Coq. However, their bitblaster functions as an independent program; they did not implement the reflection needed to use this as proof automation from within Coq itself.^[1]
Alternatively, SmtCoq *does* work as a way to discharge Coq goals, but they do this by relying on the full *SMT* capabilities. In contract, LeanSAT uses a *verified* bitblaster and then checks *SAT* certificates. 
> [!TODO]
> Explain why SAT-checking is desirable over SMT cert checking

[1]: CoqQFBV: A Scalable Certified SMT Quantifier-Free Bit-Vector Solver
[2]: SmtCoq



