# LeanSAT

- LeanSAT implements verified SAT solving in Lean. Thus, we are still able to 

- It calls out to an external, unverified, SAT-solver to produce a certificate, then the certificate is checked in verified Lean code. This way, our trusted code base is limited to Leans kernel
- This is important, because SAT solvers are notorious for being complex, filled with heuristics, and subsequently, are generally known to contain bugs (TODO: Reference needed).
- Of course, this certificate checking is extra work that a regular SAT-solver doesn't have to do.

> [!TODO]
> - In the evaluation, let's check what this cost is, by timing the harder problems for increasing sizes, and plotting the solve-time against the raw SAT-solver (probable best to compare with cadical, which is also the SAT-solver used by LeanSAT, to get clean numbers).
> 



> Here, let's write a brief overview of LeanSAT's implementation (1 to 1/2 a page, maybe?).