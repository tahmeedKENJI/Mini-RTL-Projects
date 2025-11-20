export ROOT_DIR = $(shell realpath .)

SRC = ${ROOT_DIR}/src
PKG = ${ROOT_DIR}/pkg
TST = ${ROOT_DIR}/tst
INC = ${ROOT_DIR}/inc

FLIST =  ${ROOT_DIR}/flist.f
FILES = ${shell cat $(FLIST)}

RTL ?= fifo_top
TCL ?= schematic.tcl

TOP ?= tb_top
GUI ?= 0
RUN ?= -runall

ifeq (${GUI}, 1)
	RUN = -gui
endif

run: clean build compile elab sim

clean:
	@rm -rf build;

build:
	@mkdir -p build

compile:
	@cd build; xvlog --sv -f ${FLIST};

elab:
	@cd build; xelab ${TOP} -s ${TOP} -timescale 1ns/1ps -debug all;

sim:
	@cd build; xsim ${TOP} ${RUN};
	@exit;

scheme: clean build
	@cd build; echo '#!/usr/bin/tclsh' 											> $(TCL)
	@cd build; echo "create_project in_mem_proj /tmp/in_mem_proj -in_memory"	>> $(TCL)
	@cd build; echo "set_property include_dirs {${INC}} [current_fileset]"		>> $(TCL)
	@cd build; echo "add_files {${FILES}}"                                      >> $(TCL)
	@cd build; echo "set_property top $(RTL) [current_fileset]"            		>> $(TCL)
	@cd build; echo "update_compile_order -fileset sources_1"                 	>> $(TCL)
	@cd build; echo "synth_design -top $(RTL) -rtl"     						>> $(TCL)
	@cd build; echo "start_gui"     											>> $(TCL)
	@cd build; vivado -mode batch -source ${TCL}