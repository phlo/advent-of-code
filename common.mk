.PHONY: run
run: ARGS = input
run: solve
	./$< $(ARGS)

.PHONY: test
test: ARGS = test
test: solve
	./$< $(ARGS)

.PHONY: clean
clean: CLEAN += solve
clean:
	rm -rf $(CLEAN)
