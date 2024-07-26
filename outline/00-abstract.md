<!-- An abstract should consist of six main sentences:
 1. Introduction. In one sentence, what’s the topic? -->
Bitvectors are foundational when verifying compiler backends, 
cryptographic algorithms, or hardware designs.
<!-- 2. State the problem you tackle. -->
Yet, they have a rich mathematical structure; in some contexts they behave as a ring,
in others as a boolean algebra,
and there is no single algebraic structure that captures the interactions between these behaviours.
This makes them hard to reason about with a uniform proof strategy.
<!-- 3. Summarize (in one sentence) why nobody else has adequately answered the research question yet. -->
In the fixed-width case, the problem is well-known to be NP-complete.
Despite this, SMT solvers actually do very good job at solving these problems in practice.
<!-- TODO: find some good explanation of why SMT solvers are not enough
4. Explain, in one sentence, how you tackled the research question. -->
We investigate different proof strategies in the Lean interactive theorem prover,
and provide a characterization of different classes of bitvector problems,
and which strategy will be able to solve them.
<!-- 5. In one sentence, how did you go about doing the research that follows from your big idea. -->
We've collaborated closely with the Lean community to develop a canonical library for bitvectors,
including a verified bitblaster that can solve fixed-width bitvector problems.
Then, for the arbitrary-width case, we've categorized different proof strategies:
automation for commutative rings, an extensionality principle, and
a novel finite automata-based proof strategy.
<!-- 6. As a single sentence, what’s the key impact of your research? -->
By providing a characterization of different classes of bitvector problems,
> TODO: finish this sentence


