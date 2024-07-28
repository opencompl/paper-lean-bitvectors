## Preliminaries

* Formally define our notion of bitvectors and bitvector operations
	* Mention that our bitvecs are signless
	* Informed by smt_lib and LLVM semantics
* Talk about the equivalence between bitvectors and $\mathbb Z / n\mathbb Z$

### Lean API
* Mention how the aforementioned equivalence justifies our Lean definition as (morally) `Fin (2^w)`
* We can have a sub-section