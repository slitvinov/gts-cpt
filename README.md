# introduction

The code is rescued from code.google.com/p/gts-cpt

See [README](README)

# installation

## dependencies

* gts library
  http://gts.sourceforge.net

* silo library
   http://wci.llnl.gov/simulation/computer-codes/silo

## compile

	make install

# Example

	l=-0.1 h=0.1
	n=200
	b="--begin-x $l --begin-y $l --begin-z $l"
	e="--end-x   $h --end-y   $h --end-z   $h"
	s="--size-x $n --size-y $n --size-z $n"

	cpt horse4 data/horse4.gts $b $e $s

Produces `horse4.bov` and `horse4.values` files
