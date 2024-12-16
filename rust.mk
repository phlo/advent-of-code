include ../../common.mk

FLAGS = -C opt-level=3

.PHONY: debug
debug: FLAGS = -g
debug: ARGS = test
debug: solve
	rust-gdb --args $< $(ARGS)

%: %.rs
	rustc $(FLAGS) $^
