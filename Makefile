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

.PHONY: test
test:
	@for test in `ls test_*.mojo`; do \
		$(MOJO) run $$test; \
	done
