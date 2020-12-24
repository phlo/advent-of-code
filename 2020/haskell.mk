.PHONY: run
run: solve
	./$< $(strip $(ARGS) input)

.PHONY: test
test: solve
	./$< $(strip $(ARGS) test)

solve: solve.hs
	ghc -o $@ $^

.PHONY: clean
clean:
	rm -rf *.{hi,o}
