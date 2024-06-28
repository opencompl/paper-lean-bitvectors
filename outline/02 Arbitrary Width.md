# Arbitrary Width
* In theorem provers, we like to prove bitvector equalities not up to some bounded width, but for all possible widths.
* This is also relevant in *real* verification problems, where generally we do have some bound on the width, if that bound is too large, or if there are multiple independent widths involved
	* This is because SAT-solvers solve a problem "up to 64 bits" by simply enumerating all widths less than 64. If there are two independent widths, this enumeration needs to solve $64 \times 64 = 4096$ instances. This scales horribly.

## Bitwise
* The simplest class of problems is those using only bitwise operations (i.e., and, or, xor, not).
* These operations have the property that the `i`th bit of the output depends *only* on the `i`th bits of the input.
* Thus, we can compute each bit independently
* This turns a bitvector expression (e.g., $\forall x y, x ||| y = y ||| x$) into a Boolean problem ($\forall a\,b, a || b = b || a$), which can be solved by case bashing the Booleans involved.
	* Things get a bit more complex when constants are involved. 
	* For example, 1 has a different bit in the least-significant position than in the rest of the bitvector, thus this results in two Boolean problems to be solved.
* The relevant mathematical structure: Boolean Algebras

## Ring
* Addition, multiplication, subtraction, and negation on bitvectors forms a commutative ring.
* We've reused the Mathlib-provided ring decision procedure.
* Simply by implementing the `Ring` typeclass, which involves proving that indeed these operations on bitvectors satisfy certain laws, we can then use the `ring` tactic to solve all bitvector problems involving only these ring operations.


Which brings us to our last decision procedure, involving automata.