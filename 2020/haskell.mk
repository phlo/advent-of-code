.PHONY: run
run: solve
	./$< $(strip $(ARGS) input)

.PHONY: test
test: solve
	./$< $(strip $(ARGS) test)

.PHONY: clean
clean:
	rm -rf *.{hi,o}

%: %.hs
	ghc -o $@ $^
