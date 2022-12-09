.PHONY: clean all
all:
	gcc -fPIC -o sec_part.so -c sec_part.c
	gcc -fPIC -I/usr/lib64/erlang/erts-13.1.2/include/ -shared -o part_two_nif.so sec_part_nif.c sec_part.so

clean:
	rm sec_part.so
	rm part_two_nif.so