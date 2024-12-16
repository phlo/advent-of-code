include ../../common.mk

FLAGS = -O2 -optc-O3
CLEAN = *.{hi,o}

%: %.hs
	ghc $(FLAGS) -o $@ $^
