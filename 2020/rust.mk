RFLAGS = -C opt-level=3

.PHONY: run
run: solve
	./$< $(strip $(ARGS) input)

.PHONY: test
test: solve
	./$< $(strip $(ARGS) test)

.PHONY: debug
debug: RFLAGS = -g
debug: solve
	rust-gdb --args $< $(strip $(ARGS) test)

%: %.rs
	rustc $(RFLAGS) $^
