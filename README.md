# installation

## dependencies

* gts library
* silo library

## compile

	make install

## horse test

	b="--begin-x -1.5 --begin-y -1.5 --begin-z -1.5"
	e="--end-x 1.5 --end-y 1.5 --end-z 1.5"
	s="--size-x 200 --size-y 200 --size-z 200"

	cpt horse4 data/horse4.gts $b $e $s

Produces `horse4.bov` and `horse4.values` files
