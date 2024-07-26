# Source Latex files
TEX_MAIN_PAPER = paper.tex
TEX_MAIN_SUBMISSION = submission.tex

# Generate PDF files
PDF_PAPER = paper.pdf
PDF_SUBMISSION = submission.pdf

IMAGES := $(wildcard images/*.jpg images/*.pdf images/*.png)

# grammar is a phony rule, it generates index.html
# from textidote
.PHONY: grammar

all: ${PDF_SUBMISSION} ${PDF_PAPER}

# spelling and grammar
grammar: paper.tex
	# check that textidote exists.
	@textidote --version
	# allowed to fail since it throws error if we have grammar mistakes
	-textidote --check en --output html paper.tex > index.html
	python3 -m http.server


%.tex: %.md
	pandoc -f markdown -t latex -o $@ $<

${PDF_PAPER}: ${TEX_MAIN_PAPER} ${IMAGES} \
	outline/00-abstract.tex \
	outline/01-introduction.tex \
	outline/01-LeanSAT.tex \
	outline/02-arbitrary-width.tex \
	outline/03-Automaton-Decision-Procedure.tex \
	outline/04-Non-complete-automation.tex \
	outline/05-Evaluation.tex
	latexmk ${TEX_MAIN_PAPER}

${PDF_SUBMISSION}: ${TEX_MAIN_SUBMISSION} ${IMAGES}
	latexmk ${TEX_MAIN_SUBMISSION}

paper: ${PDF_PAPER}

submission: ${PDF_SUBMISSION}

view-paper: ${TEX_MAIN_PAPER} ${IMAGES}
	latexmk -pvc ${TEX_MAIN_PAPER}

view-submission: ${TEX_MAIN_SUBMISSION} ${IMAGES}
	latexmk -pvc ${TEX_MAIN_SUBMISSION}

clean:
	latexmk -C
	rm -f outline/*.tex
