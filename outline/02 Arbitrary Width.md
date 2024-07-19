Let us shift our focus onto proving equalities of bitvector expressions for all possible widths. There are two main reasons why we're interested in doing so, even if concrete computations are generally quite limited in width: performance and modularity.

Generally, solving times for fixed-width techniques scale with the width, so in certain domains (e.g., cryptography), the widths involved might become too large for a SMT/SAT solver to solve in reasonable time.

>[!TODO] 
> Do we want to go into detail about performance here, or leave that to the evaluation (where we can back up the claims with data)?
> > This is because SAT-solvers solve a problem "up to 64 bits" by simply enumerating all widths less than 64. If there are two independent widths, this enumeration needs to solve $64 \times 64 = 4096$ instances. This scales horribly.

Furthermore, knowing an equality is true for all possible widths allows for more modular proofs in a theorem prover, where a fact is able to be reused in other contexts which might involve bitvectors of a different width.

## Bitwise
The simplest class is those of expressions comprised only of bitwise and, bitwise or, bitwise xor and bitwise complement (generally called "bitwise operations"). These operations all share the property that the $i$-th bit of the output depends *only* on the $i$-th bit of the inputs, but is independent of all other bits.

Thus, we can transform an expression over bitvectors, such as $x \mathrel{|||} y = y \mathrel{|||} x$ , into an expression over individual bits, like $\forall i, get(x \mathrel{|||} y, i) = get(x \mathrel{|||} y, i)$.
Then, we realize that the `i`-th bit of `x \mathrel{|||} y` is true iff the `i`-th bit of `x` or the `i`-th bit of `y` is set:
$$
\forall i, [ get(x, i) \mathrel{||} get(y, i) = get(y, i) \mathrel{||} get(x, i)  ]
$$
Thereby reducing an expression over bitvectors into a simple expression over a small number of Booleans, which is easily solvable. This same reduction works for all (compositions of) the mentioned operations.

Things get slightly more tricky when constants are involved. For example, 

## Ring
* Addition, multiplication, subtraction, and negation on bitvectors forms a commutative ring.
* We've reused the Mathlib-provided ring decision procedure.
* Simply by implementing the `Ring` typeclass, which involves proving that indeed these operations on bitvectors satisfy certain laws, we can then use the `ring` tactic to solve all bitvector problems involving only these ring operations.


Which brings us to our last decision procedure, involving automata.