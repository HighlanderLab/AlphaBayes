# General variables
NAME:=AlphaBayes
VERSION:= $(shell git rev-parse --short HEAD)
SUBVERSION:=0
PROGRAM:=$(NAME)$(VERSION).$(SUBVERSION)

# Set the default compiler to iFort
FC:=ifort
FFLAGS:=-O3 -DVERS=""commit-$(VERSION)""

#  If -D WEB is specified, stops will be put into AlphaBayes.

# MS Windows
ifeq ($(OS), Windows_NT)
	SRCDIR      := src/
	BUILDDIR    :=
	TARGETDIR   :=
	OSFLAG := "OS_WIN"
	## see also https://software.intel.com/en-us/compiler_winapp_f (2014-12-03)
	FFLAGS := $(FFLAGS) /static /fpp /Qmkl /Qopenmp-link:static /Qlocation,link,"${VCINSTALLDIR}/bin" /D $(OSFLAG)
	obj := .obj
	MAKEDIR :=
	exe := .exe
	CC := cl
	CFLAGS := /EHsc
	DEL := del
else
	# Linux or Mac OSX
	SRCDIR      := src/
	BUILDDIR    := objs/
	TARGETDIR   := bin/
	obj := .o
	OSFLAG := "OS_UNIX"
	# On Mac
	MKLROOT := /opt/intel/mkl
	# On Eddie2
	# MKLROOT:=/exports/applications/apps/intel/ClusterStudio2013/mkl
	# On Eddie3
	# MKLROOT := /exports/applications/apps/SL7/intel/parallel_studio_xe_2016/mkl
	MKLLIB := -L$(MKLROOT)/lib -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -openmp -lpthread -lm
	MKLINC := -I$(MKLROOT)/include
	exe :=
	FFLAGS:= $(FFLAGS) -mkl -static-intel -fpp -openmp-link=static  -module $(BUILDDIR) -D $(OSFLAG)
	uname := $(shell uname)
	MAKEDIR := @mkdir -p
	DEL := rm -rf
  	# Linux only
	ifeq ($(uname), Linux)
		FFLAGS := $(FFLAGS) -static -static-libgcc -static-libstdc++
	endif
endif

# Compile everything
all: directories $(TARGETDIR)$(NAME)$(exe) $(TARGETDIR)AlphaBayes$(exe)

directories:
	$(MAKEDIR) $(TARGETDIR)
	$(MAKEDIR) $(BUILDDIR)

# Compilation options for debugging
# With warnings about not used variables
debuglong: FFLAGS := $(FFLAGS) -traceback -g -debug all -fpp -ftrapuv -fpe0 -warn -check all

debuglong: all

# With memory checks
debug: FFLAGS := $(FFLAGS) -traceback -g -debug all -warn -check bounds -check format \
		-check output_conversion -check pointers -check uninit -fpp

debug: all

web: FFLAGS := $(FFLAGS) -D "WEB"

web: all

# If binary is made, intermediate files will be binary
binary: FFLAGS := $(FFLAGS) -D "BINARY"

binary: all
# Compile AlphaBayes
$(TARGETDIR)AlphaBayes$(exe): Makefile $(SRCDIR)AlphaBayes.f90
	@echo "Compiling AlphaBayes..."
	$(FC) $(SRCDIR)AlphaBayes.f90 $(FFLAGS) -o $(TARGETDIR)AlphaBayes$(exe)
	@echo

# Cleaning
sparklinglyclean: veryclean
	rm -rf TARGETDIR

veryclean: clean
	$(DEL) $(TARGETDIR)AlphaBayes$(exe)

clean:
	$(DEL) -rf $(BUILDDIR) *$(obj) *.mod *.dwarf *.i90 *__genmod* *~

.PHONY: make veryclean all
