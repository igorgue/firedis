MOJO = mojo

firedis:
	@mojo build firedis.🔥

.PHONY: run
run:
	@mojo run firedis.🔥

.PHONY: clean
clean:
	rm firedis
