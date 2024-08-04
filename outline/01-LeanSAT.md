# LeanSAT

LeanSAT implements a verified bitblaster in Lean, fully integrated into the system as a tactic.
Given the size of SAT problems that are produced by bitblasting, it still has to rely on high-performance SAT solvers, such as CaDiCal [@biere2024cadical].
However, these SAT solvers are not verified and can thus not be trusted by Lean.
To get around this issue LeanSAT asks the solver to produce an LRAT [@cruz2017efficient] proof certificate.
This certificate is then checked, using a Lean program with soundness proof, allowing Lean to gain trust in the correctness of the SAT solver's result.

> [!TODO]
> - What kind of knowledge about the kernel and the way that Lean proofs work internally is assumed from the reader?
> 

Unfortunately, for non-trivial Bitvector problems, the kernel is too slow to execute the certificate checker.
So instead, LeanSAT invokes a natively compiled version of the certificate checker from within the kernel.
This is done through the `ofReduceBool` axiom which extends the trusted code base with the Lean compiler itself.
Although our trusted code base is thus not as small as it could be, it is still vastly smaller and simpler than mainstream SMT solvers.
This is important because SAT solvers are notorious for being complex, filled with heuristics, and subsequently, are generally known to contain bugs (TODO: Reference needed).

> [!TODO]
> - connect this sentence in
> 

- Of course, certificate checking is extra work that a regular SAT-solver doesn't have to do.

> [!TODO]
> - In the evaluation, let's check what this cost is, by timing the harder problems for increasing sizes, and plotting the solve-time against the raw SAT-solver (probable best to compare with cadical, which is also the SAT-solver used by LeanSAT, to get clean numbers).
> 

LeanSAT's primary entry point is the tactic `bv_decide`.
This tactic uses the formally verified bitblaster to close a Lean goal by showing the assumptions to be inconsistent.
It begins by initiating a proof by contradiction, replacing the goal with `False` and adding the original goals' negation as a hypothesis.
Next, a normalization step is applied using Lean's built-in simplifier with a custom ruleset.
This normalization step has two effects:
1. It turns all hypotheses that might be of interest for the remainder of the tactic into the form `x = true` where `x` is a mixture of `Bool` and fixed-width `BitVec` expressions.
2. It applies a subset of the rewrite rules used by Bitwuzla [@niemetz2023bitwuzla] for simplification of the expressions.
Using proof by reflection, the goal is then reduced to showing that an SMTLIB-syntax-like value, representing the conjunction of all interesting assumptions, is UNSAT.
To show this, `bv_decide` applies a verified bitblasting algorithm, turning the Bitvector satisfiability problem into an AIG satisfiability one.
The AIG is designed and verified similarly to AIGNET from [@davis2013verified] and uses optimizations from [@brummayer2006local].
The reductions from Bitvectors to AIGs are collected from Bitwuzla and Z3 [@de2008z3] and proven to preserve satisfiability.
In order to use a SAT solver, the AIG is then converted to an equisatisfiable CNF, again using both the implementation and proof strategy from AIGNET.
Finally, the SAT solver is called on the CNF, producing either a counter example which gets reported to the user or an LRAT UNSAT proof certificate for the CNF.
As a last step the previously mentioned, verified, LRAT certificate checker is invoked to validate the LRAT proof certificate.
All of the equisatisfiability proofs and the soundness proofs of the LRAT checker are then combined to demonstrate that the conjunction of the hypothesis was inconsistent.

> [!TODO]
> `bv_decide?` and `bv_check`.