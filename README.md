# installation

## dependencies

* gts library
* silo library

## compile

	make install

## horse test

	l=-0.1 h=0.1
	n=200
	b="--begin-x $l --begin-y $l --begin-z $l"
	e="--end-x   $h --end-y   $h --end-z   $h"
	s="--size-x $n --size-y $n --size-z $n"

	cpt horse4 data/horse4.gts $b $e $s

Produces `horse4.bov` and `horse4.values` files
