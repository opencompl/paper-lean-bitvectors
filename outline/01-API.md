# Designining Lean's BitVector Library

Designing a good API is an essential art in productive proof engineering.
We describe the overall design of the bitvector API.
In particular, we concentrate on the definitions chosen, layers of abstraction that were built,
normal forms for stating theorems, and statistics of the library.

<!---
$ lean4/lean4/src/Init/Data/BitVec $ grep -E "^(def|abbrev|protected def|private def) " *.lean | wc -l -->
\newcommand{\NumDefsAndAbbrevs}{60}
<!---
lean4/lean4/src/Init/Data/BitVec $ grep -E "^(theorem|private theorem) " *.lean | wc -l
-->
\newcommand{\NumTheorems}{145}

<!---
lean4/lean4/src/Init/Data/BitVec $ cloc . 
-->
\newcommand{\NumLinesOfCode}{1655}

The core mechanization API consists of \NumDefsAndAbbrevs defintions and abbreviations, \NumTheorems theorems, and a total of \NumLinesOfCode LoC. 

## Design of BitVector Definitions

The low-definition of a $\texttt{BitVec} w$ is a number $n$ with a proof $\texttt{isLt} : n < 2^w$.
We choose this definition, instead of the other potential choice of a vector of booleans as this definition permits efficient implementation of all operations, both arithmetic and bitwise. Recall that Lean's kernel has special support for natural numbers via GMP, and we ensure our definitions are capable of exploiting this.
Moreover, the representation is \emph{signless} --- the bitvector itself carries no notion of being signed or unsigned.
Rather, operations on bitvectors interpret it as signed or unsigned.
This matches both the semantics of the BV SMT theory in smtlib,
as well as the semantics of compiler IRs such as LLVM.


Since a bitvector is essentialy a natural number with a constraint, we can coerce any natural number
into a bitvector by consider the number modulo $2^w$.
This is given by $\texttt{ofNat} (n :  \mathbb N) \mapsto (n % 2^w) : \texttt{BitVec}~w$.
Addition, subtraction, multiplication, and unsigned division is represented by addition and subtraction modulo $2^w$.
The result of these operations on naturals modulo $2^w$ is by definition guaranteed to be less than $2^w$,
thereby fullfilling the proof obligation `isLt`.


For bitwise operations, we reuse Lean's bitwse operations on natural numbers (once again, implemented in the kernel via GMP). We prove additional theorems that the results of bitwise operations always fits within the bitwidth.

For operations that are sign-sensitive, i.e. signed division, sign extension, signed shift rights,
we also implement coercions to and from $\mathbb Z$. `toInt` converts a bitvector into its twos
complement value, given by $(2^0 b_0 + 2^1 b_1 + \dots + 2^{w-2} b_{w-2} - 2^{w-1} b_{w-1})$.
For the other direction, `ofInt` takes an integer $i$, first brings it into range by computing $i' \equiv i % 2^n$, where modulo is the unique relation that obeys $(i = i % 2^n + (i / 2^n) * 2^n)$. Note that in particular,
this number will obey $0 \leq i % 2^n < 2^n$.
This gives us the proof that this is inbounds. So in total, we implement $\texttt{ofInt}(i) \equiv \texttt{ofNat} (i % 2^n)$. The sign sensitive operations are the built in terms of \texttt{ofInt} and \texttt{toInt}.

## Arithmetic Reasoning

\sloppypar
For arithmetic reasoning, we first prove a master theorem that says that two bitvectors are equal if their values when interpreted as natural numbers (or integers) are equal (`eq_of_toNat_eq`, `eq_of_toInt_eq`).
Next, for the arithmetic operations, we prove how the result of an arithmetic operation interpreted
as a natural number relates to the inputs interpreted as a natural number. For example, we prove that
$(a + b).toNat = (a.toNat + b.toNat) % 2^w$.

Similarly, we also prove for sign-sensitive operations, the result of coercing to an integer.
For example, we prove that $x.sshiftRight i = (x.toInt >>> i).ofInt$.
Note that this theorem cannot be written in terms of natural numbers,
since the semantics of signed shifting is crucially dependent on the signed interpretation of the argument.

To aid reasoning in complex scenarios involving `toInt`,
we prove relations between `toInt` and `toNat`, governed by the `msb` of the bitvector.
For example, we prove:

<!-- TODO: move this into a large figure with all the key theorems. -->
```
toInt_eq_toNat_cond: x.toInt =
	if x.msb
	then (x.toNat : Int) - (2^w : Nat)
	else (x.toNat : Int)
```

### Special case lemmas when no overflow occurs.

We also prove theorems that show that when no overflow is possible, the results of arithmetic expressions
do not need to be guarded by a modulo. So, we have theorems such as $(carry(a, b, w) = 0 \implies (a + b).toNat = a.toNat + b.toNat$

## Bitwise Reasoning via `getLsb`

To retrieve the value of a particular bit in a bitvector, we have the operation `v.getLsb i` which returns the value of the $i$-th least significant bit (`v.getLsb 0` is the least significant bit, while `v.getLsb (w-1)` is the most significant bit.)
This is implemented in terms of $\texttt{v.getLsb i} \equiv \texttt{v.toNat.testBit i}$,
where $\texttt{n.testBit i} \equiv 1 \&\&\& (n >>> i) \neq 0$.
We define this way as it is (as usual) fast to execute.
See that this definition is defined for all natural numbers $i$, and simply returns $0$ when $i > w$.
Furthermore, this definition is clean to reason with, provided one has sufficient theory of bitwise operations on natural numbers.
Given this definition of `getLsb`, we provide full coverage: for every bitvector operation,
we also have a theorem that describes the bits of the result of the operation.
For example, we have `getLsb (v.zeroExtend w') i = v.getLsb i`.
This enables easy bitwise reasoning.

\sid{Do we write about ext tactic and \texttt{eq\_of\_getLsb\_eq} here or elsewhere?}

## Circuit Reasoning for Addition via `unfoldr`
