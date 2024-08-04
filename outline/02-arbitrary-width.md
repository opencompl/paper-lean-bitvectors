
# TESTT

Let us shift our focus onto proving equalities of bitvector expressions for all possible widths. There are two main reasons why we're interested in doing so, even if concrete computations are generally quite limited in width: performance and modularity.

Generally, solving times for fixed-width techniques scale with the width, so in certain domains (e.g., cryptography), the widths involved might become too large for a SMT/SAT solver to solve in reasonable time.

>[!TODO] 
> Do we want to go into detail about performance here, or leave that to the evaluation (where we can back up the claims with data)?
> > This is because SAT-solvers solve a problem "up to 64 bits" by simply enumerating all widths less than 64. If there are two independent widths, this enumeration needs to solve $64 \times 64 = 4096$ instances. This scales horribly.

Furthermore, knowing an equality is true for all possible widths allows for more modular proofs in a theorem prover, where a fact is able to be reused in other contexts which might involve bitvectors of a different width.

## Bitwise
The simplest class is those of expressions comprised only of bitwise and, bitwise or, bitwise xor and bitwise complement (generally called "bitwise operations"). These operations all share the property that the $i$-th bit of the output depends *only* on the $i$-th bit of the inputs, but is independent of all other bits.

Thus, we can transform an expression over bitvectors, such as $x \mathrel{|||} y = y \mathrel{|||} x$ , into an expression over individual bits, like $\forall i, get(x \mathrel{|||} y, i) = get(x \mathrel{|||} y, i)$.
Then, we realize that the `i`-th bit of $x \mathrel{|||} y$ is true iff the `i`-th bit of `x` or the `i`-th bit of `y` is set:
$$
\forall i, [ get(x, i) \mathrel{||} get(y, i) = get(y, i) \mathrel{||} get(x, i)  ]
$$
Thereby reducing an expression over bitvectors into a simple expression over a small number of Booleans, which is easily solvable. This same reduction works for all (compositions of) the mentioned operations.

Things get slightly more tricky when constants are involved. For example, 

## Ring

A commutative ring is an algebraic structure that has $(R,  0, 1, +, *)$, where $+$ is associative, commutative, invertible, $*$ is associative, $0$ is the additive identity, $1$ is the multiplicative identity, and $*$ distributes over $+$. Rings are ubiquitous, and common examples include the integers, rationals, and reals. Moreover, bitvectors with their arithmetic operators also for a ring. Concretely, a bitvector of width $w$ is isomorphic to the ring $\mathbb Z /2^w \mathbb Z$. 

Free theorems, that is, equalities which hold in *all* ring structures, are known to be decidable by rewriting both sides of the equality to a normal form and checking for syntactic equality. Mathlib, Lean's mathematical library [[@themathlibcommunityLeanMathematicalLibrary2020]], implement this decision procedure as its `ring` tactic. We prove that the bitvectors do indeed form a commutative ring, and use the ring instance to prove arithmetic identities. 

Interestingly, pure algebraic reasoning is not only capable of proving infinite width assertions, but is also sometimes much faster than direct bitblasting. For example, the identity $\forall x, y, x * y = y * x$ is immediate by rewriting to normal form via `ring`, but requires equivalence checking of SAT formulae of size $O(w^2)$, which is much more expensive! 

Note that since bitvectors are isomorphic to $\mathbb Z / 2^w \mathbb Z$, they witness more equations than just the free theorems decided by `ring`. For example, the ring has characteristic $2^w$, and so, for example, admits the equation  $1 + 1 + \dots + (2^w~\mathsf{times}) = 0$. This equation is clearly not true in $\mathbb Z$, thus would not be proven by `ring`. 

> [!TODO]
> (This needs to define rigirously what a BVExpr is, and why it's an element of $\mathbb Z[X]$, and how more generally it's an element of $\mathbb Z[X_1, \dots, X_n]$. 
> Also, be more specific about what "overflow" means here (I think we only care about *signed* overflow)

However, suppose we have a bitvector expression $e \in \mathbb Z[X]$ which is known not to overflow. Let $\iota : \mathbb Z[X] \to \mathbb Z/nZ[X]$ be the canonical injection. Then, we have that $e = 0$ if and only if $f(e) = 0$. Therefore, we can verify the expression directly over $\mathbb Z[X]$, which is the free ring over two generators, for which the ring decision procedure is complete. Consequently, deciding arithmetic equalities over any expression $e$ that does not overflow is complete via the ring tactic.
