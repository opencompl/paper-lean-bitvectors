# Introduction

Effectively reasoning about bitvectors is foundational for program verification. Bitvectors model integer operations in compiler intermediate representations (e.g., LLVM-IR [@zhao2012formalizing]) and machine code [@armstrong2019isa; @reid2016trustworthy], combinational logic in hardware designs [Chipala], and are a central component when modelling floating point arithmetic [?]. While assembly code uses fixed-width bitvectors of a small width (e.g., 32 or 64), specialised hardware for cryptography [@stelzer2023enabling;@cammarota2022intel] and many hardware designs require fixed but wide bitvectors. Bitvectors are also a widely-used theory in SMT solvers [@de2008z3;@barrett2011cvc4;@barbosa2022cvc5], where SMT solvers expose user-facing fixed-width bitvectors through smtlib [@barrett2010smt] and internally use width-agnostic bitvector rewrites when canonicalising SMT formulas. Consequently, a comprehensive theory of Bitvectors is critical for a program verification software ecosystem.

  

Today, there are three main approaches for reasoning about BitVectors: (a) SMT solvers provide a fully automatic – but partial – black box solution for fixed-width BitVector reasoning, (b) interactive theorem provers provide a universal white box solution driven by a human developer supported by automation, and (c) the no-formalism approach where programmers use integer types in their programming language informally applying bitvector knowledge as documented in books such as Hacker's Delight [@warren2013hacker]. While each approach has complementary strengths, we lack a solution where automation, developer-guided proofs, and programming language support for bitvectors are first-class across all three dimensions.

  

SMT solvers are excellent at solving equations about fixed-width bitvectors, as their finite domain permits effective reductions to SAT. Reducing bitvector decision problems to SAT via bitblasting has been widely successful across various domains. However, the way they work means they *only* work automatically. Thus, once we step outside what an SMT solver can do, either practically (the SMT solver might time out if the problem we give it is too large) or fundamentally (SMT solvers can only prove equalities up to some *bounded* width, not for arbitrary widths), the SMT solver is unable to help. There is no way to combine some insight from the user with the SMT solver's capabilities: either the tool works and proves (or disproves) the equality as a whole, or the SMT solver is inconclusive, leaving the user without information or a path towards a potential solution.

  

Interactive theorem provers (ITPs) allow for limitless bitvector reasoning: they can express both fixed-width and bit-width-generic theorems, while proofs are only limited by the mathematical abilities of the proof engineer. Big formal verification efforts such as CompCert [@leroy2016compcert], [DeepSpec], and [Chipala] for the end-to-end verification of compilers, as well as efforts to verify an SAT solver [cite], have resulted in several BitVector libraries in COQ [A, B, C], with no official support across all of them. Isabelle is particularly well-known for the powerful automation it gains from the close integration of proof-producing SMT solvers, which also applies to its ability to reason about BitVectors. Yet, <...>. Finally, while both Isabell and COQ support code extraction, they are primarily a proof environment and less a programming language.

In this work, we make a case for unified first-class bitvector support in an interactive theorem prover that delivers along all three dimensions: (a) automation, (b) extensibility, and (c) programmability. In particular, we present a comprehensive theory of bitvector reasoning that is complete for either fixed-width reasoning, or for arbitrary-width reasoning over specific classes of operations.

  

For fixed-width reasoning, we use LeanSAT, which employs a verified bitblaster, and a certificate-producing SAT solver, together with a verified certificate checker. 

  

To make performance more reliable, SMT solvers rely on a host of canonicalization rules. For example, a multiplication $x * 2^y$ might be rewritten as a shift $x <<< y$, since shifting is easier (thus more performant) to bitblast. To justify these canonicalizations within Lean, we have to prove the equality holds for all possible widths.

  

Deciding such equalities is known to be undecidable in general, so there is no hope to write reliable proof automation for all possible properties. However, we can write decision procedures for expressions with a limited set of operations.

We identify, and provide Lean proof automation for, three such classes. Namely, when the property of interest contains:

* Only bitwise operations (and, or, not, xor), or
* Only addition and multiplication, assuming that these don't overflow, or
* Only addition, bitwise operations and left shift by a constant

  
Finally, we evaluate these decision procedures by looking at a big corpus of real-world bitvector equalities, taken from the domain of compiler optimizations, to see what portion of real-world problems fall within the classes we are able to solve.

  

Our contributions are:

* First-class bit vectors for interactive theorem proving: design and implementation of a bitvector theory, its close integration with fixed and arbitrary-width decision procedures, and the deep integration of our system in a modern modern theorem prover -- offering streamlined bit vector reasoning for proof engineering
* A fully integrated tactic to discharge fixed-width bitvector goals, by using reflection, a verified bitblaster, and SAT certificate checking
* An automata based verified decision procedure which can solve a mix of arbitrary-width bitwise and arithmetic operations, and use it to build a simplification pass for bitvector goals
* An overview of existing bitvector decision procedures, proof automation in general, and the bitvector equalities they can solve.


### Related Work

#### Bitvector decision procedures 

Bitwuzla, Boolector, Cadical, DPLL/CDCL, general frameworks

#### Proof Automation for Bitvector Theory

SmtCoq integrates an SMT solver with Coq, but they do this by relying on the full SMT capabilities. In contract, LeanSAT uses a *verified* bitblaster and then checks *SAT* certificates. While SMT is much more powerful, it lacks a standardized proof format.
This is in contrast to SAT, with it's standardized LRAT certificate format. Moreover, LRAT proofs take time linear in the size of the proof to check, enabling LeanSAT to efficiently verify unsat. In contrast, SmtCoq relies on CVC4's non-standard certificate, which is both expensive to check, and also does not permit interoperability between different SMT solvers. Thus, for our use-case, SAT certificates are the right choice. This is evidenced in our evaluation, where we see that LeanSAT scales better than SMTCoq, both in terms of weak scaling (i.e., we scale linearly in the problem size) and in absolute terms (i.e., we are YYx faster (geomean) to SmtCoq.

Shi et al. built a verified bitblaster in Coq. However, their bitblaster functions as an independent program; they did not implement the reflection needed to use this as proof automation from within Coq itself.^[1]  

More importantly, while Coq does have the ability to extract executable code, Lean is explicitly also a general purpose programming language, and running Lean code is a first-class concern in the ecosystem.
This is exemplified by the representation of bitvectors: most Coq bitvector libraries (e.g, [A], [B], [C]) represent a bitvector simply as a list of Booleans. This makes a lot of sense from the verification standpoint, since this is indeed how we tend to think of bitvectors, but results in poor runtime behaviour when one actually tries to execute a program using these bitvectors. Lean's standard bitvector representation, in contrast, is a natural number, coupled with a proof that this number is strictly less than $2^w$, where $w$ is the width of the bitvector. This allows us to make use of Lean's fast computation of natural numbers, but does mean we have to put in more work in the form of extra API to recover the simpler list of bits viewpoint in proofs.


Isabelle and HOL light are proof assistants which are based on higher order logic, and have a culture of providing strong proof automation. In particular, they provide reductions to has automation for bitvectors as well Stuff stuff HOL vs dependent typing, stuff stuff some old paper in the 90s by larry and john where they claimed to have solved the problem forever.

#### Hammer-style Proof Automation

A particular style of providing proof automation, pioneered by Isabelle and HOL Light is to convert proof search into first order logic (potentially enriched with theories). Then, a FOL solution provides the relevant lemmas that are necessary to prove the goal in HOL, where a new proof search is restarted (cite Metis). An alternative strategy, which is much more complicated, is to perform proof reconstruction, where a higher order logic proof is reconstructed from the first order logic solution. A long line of work has gone into this (literally scrape larry's publications from 2000 to 2010). However, this style of proof automation is best effort, and heavily relies on having the correct lemmas in scope for the first order logic proof search to succeed. In contrast, we setup decision procedures which are guaranteed to decide bitvector theories (given enough time), but are much more narrow in scope. 


[1]: CoqQFBV: A Scalable Certified SMT Quantifier-Free Bit-Vector Solver

[2]: SmtCoq



