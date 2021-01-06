CFLAGS = -O2 -optc-O3

.PHONY: run
run: ARGS = input
run: solve
	./$< $(ARGS)

.PHONY: test
test: ARGS = test
test: solve
	./$< $(ARGS)

.PHONY: clean
clean:
	rm -rf *.{hi,o}

%: %.hs
	ghc $(CFLAGS) -o $@ $^
