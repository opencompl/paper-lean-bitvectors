# Heuristics-based automation

* This concludes the *decision procedures*, which are guaranteed to solve all problems in a specific class.
* However, we also have other automation, which will solve only particular instances, or only partially solve other instances.
	* This is not as reliable as full-blown decision procedures
	* But, still very useful to make the live of expert users easier when doing their manual proofs.

 >[!TODO]
 >- In this section we can talk about general API design, and the various `simp` lemmas we've proven
 >- Canonicalization (i.e., simp normal forms) is a big thing
 >- Potentially, we move the discussion of 2-adic multiplication here, to frame it as one of these "non-complete" automations


> Alex:
> Probably, we don't want to mention 2-adic multiplication at all, which removes much of the need of this section. We can move the discussion of basic AP
design to the Preliminaries section.
>
> On the other hand, part of our justification of caring about arbitrary-width rewrites lies in needing canonicalization lemmas to make LeanSAT work nice
 If we do actually implement (and evaluate!) such a heuristic preprocessing step, this would be the section to talk about it.


> Tobias:
> Why did we decide to drop this section about 2-adics?