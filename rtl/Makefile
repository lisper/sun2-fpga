
all: bootprom_h.v bootprom_l.v bootprom_patched_l.v bootprom_patched_h.v

clean:
	rm -f bootprom_h.v bootprom_l.v bootprom_patched_l.v bootprom_patched_h.v
	rm -f *.vcd *.log

bootprom_l.v: rom
	./rom 0 <../media/sun2-multi-rev-R.bin >bootprom_l.v

bootprom_h.v: rom
	./rom 1 <../media/sun2-multi-rev-R.bin >bootprom_h.v

bootprom_patched_l.v: rom ../boot/sun2-multi-rev-R-patched.bin
	./rom 0 <../boot/sun2-multi-rev-R-patched.bin >bootprom_patched_l.v

bootprom_patched_h.v: rom ../boot/sun2-multi-rev-R-patched.bin
	./rom 1 <../boot/sun2-multi-rev-R-patched.bin >bootprom_patched_h.v

rom: rom.c
	cc -o rom rom.c

PALS = \
	pal20X10_u211.v \
	pal20L10_u212.v \
	pal16R4_u213.v \
	pal16R4_u316.v \
	pal16R8_u602.v \
	pal16R4_u718.v

TOP = top_ttl.v sun2_ttl.v

ROM_INC = \
	bootprom_l.v \
	bootprom_h.v

ROMS = \
	ttl_74S288_idprom.v \
	ttl_27256_h.v \
	ttl_27256_l.v

RAMS = \
	ttl_2168_sram.v

TTL = \
	ttl_74F74.v \
	ttl_74F138.v \
	ttl_74LS148.v \
	ttl_74F151.v \
	ttl_74LS244.v \
	ttl_74F251.v \
	ttl_74F257.v \
	ttl_74LS273.v \
	ttl_74F374.v \
	ttl_74LS393.v \
	ttl_74S491.v \
	ttl_74LS534.v \
	ttl_74LS633.v  \
	ttl_74LS640.v \
	ttl_25LS2518.v \
	ttl_58167.v

CHIPS = \
	ttl_am2949.v \
	ttl_am9513.v \
	ttl_Z8530.v

