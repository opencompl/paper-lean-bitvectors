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
