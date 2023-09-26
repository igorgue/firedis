MOJO = mojo

.PHONY: firedis
firedis:
	mojo build firedis.🔥
	@mkdir -p bin
	mv firedis bin/firedis

.PHONY: run
run:
	@mojo run firedis.🔥

.PHONY: clean
clean:
	rm bin/firedis

.PHONY: test
test:
	@$(MOJO) run test.mojo
