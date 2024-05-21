EXAMPLE_FLAGS = -I./examples -O0 -g3
EXAMPLE_MODFLAGS = $(EXAMPLE_FLAGS) -fportcosmo -DUSING_PLUGIN=1\
				   -include examples/tmpconst.h
EXAMPLE_RESFLAGS = $(EXAMPLE_FLAGS)\
				   -include examples/tmpconst.h

EXAMPLE_SOURCES = $(wildcard examples/ex*.c)
EXAMPLE_RUNS = $(EXAMPLE_SOURCES:%.c=%.runs)
EXAMPLE_MODBINS = $(EXAMPLE_SOURCES:examples/%.c=examples/modded_%)
EXAMPLE_RESBINS = $(EXAMPLE_SOURCES:examples/%.c=examples/result_%)

EXAMPLE_BINS = $(EXAMPLE_MODBINS) $(EXAMPLE_RESBINS)

all: $(EXAMPLE_RUNS) $(EXAMPLE_BINS)

./examples/%.runs: ./examples/modded_% ./examples/result_%
	diff -ys <($(word 2,$^)) <($(word 1,$^))

./examples/%.o: ./examples/%.c ./examples/tmpconst.h
	$(CC) $(EXAMPLE_FLAGS) $< -c -o $@

./examples/modded_%.o: ./examples/%.c
	$(CC) $(EXAMPLE_MODFLAGS) $< -c -o $@

./examples/modded_%.o: ./examples/%.cc
	$(CXX) $(EXAMPLE_MODFLAGS) $< -c -o $@

./examples/modded_%: ./examples/modded_%.o ./examples/functions.o ./examples/supp.o
	$(CC) -o $@ $^

./examples/result_%.o: ./examples/%.c
	$(CC) $(EXAMPLE_RESFLAGS) $< -c -o $@

./examples/result_%.o: ./examples/%.cc
	$(CXX) $(EXAMPLE_RESFLAGS) $< -c -o $@

./examples/result_%: ./examples/result_%.o ./examples/functions.o
	$(CC) -o $@ $^

clean:
	rm -f ./examples/*.o
	rm -f $(EXAMPLE_BINS)
	rm -f $(EXAMPLE_RUNS)
	rm -f ./src/*.o ./src/ifswitch/*.o ./src/initstruct/*.o
