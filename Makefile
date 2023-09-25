#
# Copyright (c) 2015 Andrew Ayer
#
# See COPYING file for license information.
#

CXXFLAGS ?= -Iopenssl-dist/$(ARCH)/include -Wall -pedantic -Wno-long-long -O2
CXXFLAGS += -std=c++11

OBJFILES = \
    git-crypt.o \
    commands.o \
    crypto.o \
    gpg.o \
    key.o \
    util.o \
    parse_options.o \
    coprocess.o \
    fhstream.o

OBJFILES += crypto-openssl-10.o crypto-openssl-11.o
LDFLAGS += -Lopenssl-dist/lib -lcrypto

all: build

#
# Build
#
BUILD_TARGETS := build-bin

build: $(BUILD_TARGETS)

build-bin: git-crypt

git-crypt: $(OBJFILES)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJFILES) $(LDFLAGS)

util.o: util.cpp util-unix.cpp util-win32.cpp
coprocess.o: coprocess.cpp coprocess-unix.cpp coprocess-win32.cpp

#
# Clean
#
CLEAN_TARGETS := clean-bin clean-logs

clean: $(CLEAN_TARGETS)

clean-bin:
	rm -f $(OBJFILES) git-crypt
	rm -rf openssl-dist

clean-logs:
	rm -f build-*.txt

.PHONY: all build build-bin clean clean-bin clean-logs
