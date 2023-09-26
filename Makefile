MOJO = mojo

.PHONY: firedis
firedis:
	@echo "Building firedis in release mode"
	mojo build firedis.🔥
	@mkdir -p bin
	mv firedis bin/firedis

.PHONY: firedis.debug
firedis.debug:
	@echo "Building firedis in debug mode"
	mojo build --debug-level "full" firedis.🔥
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
