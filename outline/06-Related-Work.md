
# Related Work

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


