#
# $Header$
#
# ora8 --
#
#      Makefile for ora8 database driver.
#

ifdef INST
NSHOME ?= $(INST)
else
NSHOME ?= ../aolserver
endif

#
# Module name
#
MOD      =  ora8.so
MODCASS  =  ora8cass.so

#
# Objects to build
#
OBJS     =  ora8.o
OBJSCASS =  ora8cass.o

#
# Header files in THIS directory
#
HDRS     =  

#
# Extra libraries
#
MODLIBS  =  -L$(ORACLE_HOME)/lib \
    -lclntsh -lcore8 -lcommon8 -lgeneric8 -lclient8

########################################################################
# Copied from Makefile.module because this module is a little more
# complicated.

# TODO: this should be possible to manage without maintaining a local copy of
# Makefile.module

include $(NSHOME)/include/Makefile.global

# Tack on the oracle includes after Makefile.global stomps CFLAGS
CFLAGS += \
    -I$(ORACLE_HOME)/rdbms/demo \
    -I$(ORACLE_HOME)/rdbms/public \
    -I$(ORACLE_HOME)/network/public \
    -I$(ORACLE_HOME)/plsql/public 

all: $(MOD) $(MODCASS)

# Override LIBS variable
LIBS=

$(MOD): $(OBJS)
	$(RM) $@
	$(LDSO) -o $@ $(OBJS) $(MODLIBS)

$(MODCASS): $(OBJSCASS)
	$(RM) $@
	$(LDSO) -o $@ $(OBJSCASS) $(MODLIBS)

$(OBJS): $(HDRS)

$(OBJSCASS): $(HDRS) ora8.c
	$(CC) $(CFLAGS) -DFOR_CASSANDRACLE=1 -o $@ -c $<

install: all
	$(RM) $(INSTBIN)/$(MOD)
	$(INSTALL_SH) $(MOD) $(INSTBIN)/
	$(RM) $(INSTBIN)/$(MODCASS)
	$(INSTALL_SH) $(MODCASS) $(INSTBIN)/

clean:
	$(RM) $(OBJS) $(MOD) $(OBJSCASS) $(MODCASS)

clobber: clean
	$(RM) *.so *.o *.a *~

distclean: clobber
	$(RM) TAGS core

