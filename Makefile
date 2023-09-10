MOJO = mojo

firedis:
	@mojo build firedis.🔥

.PHONY: run
run:
	@mojo run firedis.🔥

.PHONY: run.python
run.python:
	@python3 -m firedis

.PHONY: clean
clean:
	rm firedis
