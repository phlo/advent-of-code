.PHONY: run
run: solve
	./$< 25 input

.PHONY: test
test: solve
	./$< 5 test

solve: solve.hs
	ghc -o $@ $^

.PHONY: clean
clean:
	rm -rf *.{hi,o}
