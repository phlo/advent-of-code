CFLAGS = -C opt-level=3

.PHONY: run
run: ARGS = input
run: solve
	./$< $(ARGS)

.PHONY: test
test: ARGS = test
test: solve
	./$< $(ARGS)

.PHONY: debug
debug: RFLAGS = -g
debug: ARGS = test
debug: solve
	rust-gdb --args $< $(ARGS)

%: %.rs
	rustc $(CFLAGS) $^
