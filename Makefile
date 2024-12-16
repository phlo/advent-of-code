clean: $(shell ls -1d */*)
	for i in $^; do $(MAKE) -C $$i $@; done
