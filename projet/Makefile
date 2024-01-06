# Makefile for Le Compiltapeur

OCAMLBUILD = ocamlbuild
TARGET = main.byte
TESTS_DIR = tests
RESULTS_DIR = results

all:
	$(OCAMLBUILD) -use-menhir $(TARGET)

clean:
	$(OCAMLBUILD) -clean
	rm -f $(TARGET)
	rm -f $(RESULTS_DIR)/*.s

test: all
	@for test_file in $(TESTS_DIR)/basic/*.test $(TESTS_DIR)/advanced/*.test $(TESTS_DIR)/*.test; do \
		echo "Running test: $$test_file"; \
		./$(TARGET) $$test_file > $(RESULTS_DIR)/$$(basename $$test_file .test).s; \
	done
