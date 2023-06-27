
all: sun2-multi-rev-R-patched.bin

sun2-multi-rev-R-patched.bin: patch.txt patchrom
	./patchrom ../media/sun2-multi-rev-R.bin sun2-multi-rev-R-patched.bin <patch.txt

patchrom: patchrom.c
	cc -o patchrom -g patchrom.c
