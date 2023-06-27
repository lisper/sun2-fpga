#include <stdio.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>

unsigned char data[32*1024];
unsigned short words[16*1024];

void usage()
{
    fprintf(stderr, "usage: patchrom <in-file> <out-file>\n");
    fprintf(stderr, "reads patches from stdin...\n");
    exit(1);
}

void patch()
{
	char line[1024];
	while (fgets(line, sizeof(line), stdin)) {
		unsigned addr, addr2, p1, p2;
		if (strlen(line) < 2) continue;
		if (line[0] == '#') continue;
					    
		addr = addr2 = p1 = p2 = 0;
		int n = sscanf(line, "%x %x %x %x\n", &addr, &p1, &p2, &addr2);
		printf("n %d; %x %x %x %x\n", n, addr, addr2, p1, p2);

		int offset = addr - 0xef0000;
		if (n == 2 || n == 3) {
			unsigned old = words[offset/2];
			if (old != p1) {
				printf("mismatch 1st %x %04x %04x\n", addr, old, p1);
				exit(3);
			}
			words[offset/2] = 0x4e71;
		}
		if (n == 3) {
			unsigned old = words[offset/2 + 1];
			if (old != p2) {
				printf("mismatch 2nd %x %04x %04x\n", addr, old, p2);
				exit(3);
			}
			words[offset/2 + 1] = 0x4e71;
		}
		if (n == 4) {
			unsigned offset2 = addr2 - 0xef0000;
			printf("patch offset %x - %x\n ", offset, offset2);
			for (int o = offset; o <= offset2; o += 2) {
				words[o/2] = 0x4e71;
			}
		}
	}
}

int main(int argc, char *argv[])
{
    int ret, low = 0, a = 0;;
    int fin, fout;

    if (argc != 3) usage();

    fin = open(argv[1], O_RDONLY);
    if (fin < 0) {
	    perror(argv[1]);
	    return 1;
    }
    
    fout = open(argv[2], O_WRONLY | O_CREAT, 0666);
    if (fout < 0) {
	    perror(argv[2]);
	    return 1;
    }
    
    ret = read(fin, data, sizeof(data));
    if (ret > 0) {
	    for (int i = 0; i < 32*1024; i += 2) {
		    words[i/2] = (data[i] << 8) | data[i+1];
	    }

	    patch();
	    
	    for (int i = 0; i < 32*1024; i += 2) {
		    data[i+0] = words[i/2] >> 8;
		    data[i+1] = words[i/2];
	    }
    }

    ret = write(fout, data, sizeof(data));
    if (ret < 0) {
	    perror(argv[2]);
	    return 2;
    }

    exit(0);
}
