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