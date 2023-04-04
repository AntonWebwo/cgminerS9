XILINX_BASE_PATH=$(CURDIR)/build-tools/gcc-linaro-arm-linux-gnueabihf-4.7-2012.11-20121123_linux
XILINX_OTHER_LIB_BASE_PATH=$(CURDIR)/build-tools/prebuilt-libz/linux-armhf
USR = $(XILINX_BASE_PATH)/arm-linux-gnueabihf/libc/usr
XILINX_INC = $(USR)/include
XILINX_LIBDIR = $(USR)/lib

MY_CFLAGS = -O2 -pthread -I$(XILINX_INC) -L$(XILINX_LIBDIR) -I./ -I./ccan/opt -I./compat/jansson-2.6/src -I./lib -I$(XILINX_OTHER_LIB_BASE_PATH)/include
MY_LIBS   = -lm -lrt $(XILINX_OTHER_LIB_BASE_PATH)/lib/libz.a
CPPFLAGS  = 
LDFLAGS   = 
SRCDIRS   = . ccan/opt compat/jansson-2.6/src lib
PROGRAM   = bmminer
SRCEXTS = .c .C .cc .cpp .CPP .c++ .cxx .cp
HDREXTS = .h .H .hh .hpp .HPP .h++ .hxx .hp
CFLAGS  = 
CXXFLAGS= 
CC     = $(XILINX_BASE_PATH)/bin/arm-linux-gnueabihf-gcc
CXX    = $(XILINX_BASE_PATH)/bin/arm-linux-gnueabihf-g++
RM     = rm -f
ETAGS = etags
ETAGSFLAGS =
CTAGS = ctags
CTAGSFLAGS =

## Stable Section: usually no need to be changed. But you can add more.
##==========================================================================
SHELL   = /bin/sh
EMPTY   =
SPACE   = $(EMPTY) $(EMPTY)
ifeq ($(PROGRAM),)
  CUR_PATH_NAMES = $(subst /,$(SPACE),$(subst $(SPACE),_,$(CURDIR)))
  PROGRAM = $(word $(words $(CUR_PATH_NAMES)),$(CUR_PATH_NAMES))
  ifeq ($(PROGRAM),)
    PROGRAM = a.out
  endif
endif
ifeq ($(SRCDIRS),)
  SRCDIRS = .
endif
SOURCES = $(foreach d,$(SRCDIRS),$(wildcard $(addprefix $(d)/*,$(SRCEXTS))))
HEADERS = $(foreach d,$(SRCDIRS),$(wildcard $(addprefix $(d)/*,$(HDREXTS))))
SRC_CXX = $(filter-out %.c,$(SOURCES))
OBJS    = $(addsuffix .o, $(basename $(SOURCES)))
DEPS    = $(OBJS:.o=.d)

## Define some useful variables.
DEP_OPT = $(shell if `$(CC) --version | grep "GCC" >/dev/null`; then \
                  echo "-MM -MP"; else echo "-M"; fi )
DEPEND      = $(CC)  $(DEP_OPT)  $(MY_CFLAGS) $(CFLAGS) $(CPPFLAGS)
DEPEND.d    = $(subst -g ,,$(DEPEND))
COMPILE.c   = $(CC)  $(MY_CFLAGS) $(CFLAGS)   $(CPPFLAGS) -c
COMPILE.cxx = $(CXX) $(MY_CFLAGS) $(CXXFLAGS) $(CPPFLAGS) -c
LINK.c      = $(CC)  $(MY_CFLAGS) $(CFLAGS)   $(CPPFLAGS) $(LDFLAGS)
LINK.cxx    = $(CXX) $(MY_CFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)

.PHONY: all objs tags ctags clean distclean help show

# Delete the default suffixes
.SUFFIXES:

all: $(PROGRAM)

# Rules for creating dependency files (.d).
#------------------------------------------

%.d:%.c
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

%.d:%.C
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

%.d:%.cc
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< $@

%.d:%.cpp
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

%.d:%.CPP
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

%.d:%.c++
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

%.d:%.cp
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

%.d:%.cxx
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

# Rules for generating object files (.o).
#----------------------------------------
objs:$(OBJS)

%.o:%.c
	$(COMPILE.c) $< -o $@

%.o:%.C
	$(COMPILE.cxx) $< -o $@

%.o:%.cc
	$(COMPILE.cxx) $< -o $@

%.o:%.cpp
	$(COMPILE.cxx) $< -o $@

%.o:%.CPP
	$(COMPILE.cxx) $< -o $@

%.o:%.c++
	$(COMPILE.cxx) $< -o $@

%.o:%.cp
	$(COMPILE.cxx) $< -o $@

%.o:%.cxx
	$(COMPILE.cxx) $< -o $@

# Rules for generating the tags.
#-------------------------------------
tags: $(HEADERS) $(SOURCES)
	$(ETAGS) $(ETAGSFLAGS) $(HEADERS) $(SOURCES)

ctags: $(HEADERS) $(SOURCES)
	$(CTAGS) $(CTAGSFLAGS) $(HEADERS) $(SOURCES)

# Rules for generating the executable.
#-------------------------------------
$(PROGRAM):$(OBJS)
ifeq ($(SRC_CXX),)              # C program
	$(LINK.c)   $(OBJS) $(MY_LIBS) -o $@
	@echo Type ./$@ to execute the program.
else                            # C++ program
	$(LINK.cxx) $(OBJS) $(MY_LIBS) -o $@
	@echo Type ./$@ to execute the program.
endif

# TANG MODIFY START
#ifndef NODEP
ifdef NODEP
# TANG MODIFY END
ifneq ($(DEPS),)
  sinclude $(DEPS)
endif
endif

clean:
	$(RM) $(OBJS)

distclean: clean
	$(RM) $(DEPS) TAGS

# Show help.
help:
	@echo 'Generic Makefile for C/C++ Programs (gcmakefile) version 0.5'
	@echo 'Copyright (C) 2007, 2008 whyglinux <whyglinux@hotmail.com>'
	@echo
	@echo 'Usage: make [TARGET]'
	@echo 'TARGETS:'
	@echo '  all       (=make) compile and link.'
	@echo '  NODEP=yes make without generating dependencies.'
	@echo '  objs      compile only (no linking).'
	@echo '  tags      create tags for Emacs editor.'
	@echo '  ctags     create ctags for VI editor.'
	@echo '  clean     clean objects and the executable file.'
	@echo '  distclean clean objects, the executable and dependencies.'
	@echo '  show      show variables (for debug use only).'
	@echo '  help      print this message.'
	@echo
	@echo 'Report bugs to <whyglinux AT gmail DOT com>.'

# Show variables (for debug use only.)
show:
	@echo 'PROGRAM     :' $(PROGRAM)
	@echo 'SRCDIRS     :' $(SRCDIRS)
	@echo 'HEADERS     :' $(HEADERS)
	@echo 'SOURCES     :' $(SOURCES)
	@echo 'SRC_CXX     :' $(SRC_CXX)
	@echo 'OBJS        :' $(OBJS)
	@echo 'DEPS        :' $(DEPS)
	@echo 'DEPEND      :' $(DEPEND)
	@echo 'COMPILE.c   :' $(COMPILE.c)
	@echo 'COMPILE.cxx :' $(COMPILE.cxx)
	@echo 'link.c      :' $(LINK.c)
	@echo 'link.cxx    :' $(LINK.cxx)

## End of the Makefile ##  Suggestions are welcome  ## All rights reserved ##
#############################################################################
