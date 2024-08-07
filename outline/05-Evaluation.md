# Evaluation

We evaluate our decision procedure, both for finite and arbitrary widths, against a corpus of bitvector equations from the domain of compiler optimizations. Specifically, we look at rewrites of LLVM IR, obtained from the test-suite^[TODO: link to the directory that contains the original test in the LLVM source code repo] of LLVM's peephole optimization pass, InstCombine, and from Alive2, a translation validation tool for LLVM IR [[@lopesAlive2BoundedTranslation2021]].

* LLVM IR has more than just bitvector ops (e.g., load/store, but also vector math or floating point)
* We thus filter out test cases which have any operations beyond: op1, op2, etc. (TODO: actually list these)
* This leaves us with XX rewrites from LLVM's test suite, and YY rewrites from

## LeanSAT
First, let us quantify the cost of verified SAT-solving.
>[!TODO]
>I'd like to run some experiments where we take a corpus of bitvector problems (involving only one width!) and measure how long it takes to solve them for various, increasing, concrete sizes (say: 4 bits, 8 bits, 12 bits, 16 bits, ..., up to 64 bits), both inside of LeanSAT *and* directly in Cadical.
>
>This will let us quantify the extra work LeanSAT is doing in certificate checking. The expectation is that this relative cost will strongly negatively correlates with the size of the problem we're solving, since SAT-solving is NP-hard, but certificate checking is P. 
>
>We could create a nice plot out of this, e.g. by plotting the average solve time over the whole corpus on the y-axis, and the problem size on the x-axis, having two lines (one for LeanSAT, one for plain Cadical).
>Alternatively, we have only one line, and put the relative slowdown on the y-axis. Depends a bit on what the numbers are and which plot looks more impressive.

Then, take a look at some bitvector problems using `select`, and observe how the SMT solver chokes on even relatively small widths



## Arbitrary Width
Now let us now consider the arbitrary-width version of that same corpus of bitvector equalities.

>[!TODO]
>Make a nice pie chart that subdivides our bitvector problems into:
>- Purely bitwise
>- Purely `ring`
>- Automaton-solveable
>- Manually proven/provable through bisimulation technique
>- Unproven






