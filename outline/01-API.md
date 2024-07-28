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
