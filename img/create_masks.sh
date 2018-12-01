#!/bin/sh

for f in heart liver kidney lungs brain; do
	convert "${f}.png" -alpha extract "${f}_mask.pbm"
done
