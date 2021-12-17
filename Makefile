run: $(shell ls -1dv */)
	for i in $^; do $(MAKE) -C $$i; done
