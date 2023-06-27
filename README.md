# sun2-fpga
fpga implementaion of sun-2 workstation using a real 68010 chip.

The idea is to implement everything *except* the 68010 cpu in an FPGA.  Then create a PCB with
the FPGA and a socket for the 68010.

The peripheral chips (timer, scc) are minimal, and 'just enough' to support booting and SunOS.
The memory and video are implemented new, using modern parts, but emulate the interface to the system.

Not sure what I'll do about SCSI yet.  Most likely a minimal implementation backed by an MMC card.



