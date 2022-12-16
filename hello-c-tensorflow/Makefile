build: hello

hello: main.c
	$(CC) $(CFLAGS) -ltensorflow -o hello main.c

BINDIR ?= $(DESTDIR)/usr/bin
install: hello
	install -D --mode=755 hello ${BINDIR}/hello
