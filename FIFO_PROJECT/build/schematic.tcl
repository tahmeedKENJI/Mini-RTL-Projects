#!/usr/bin/tclsh
create_project in_mem_proj /tmp/in_mem_proj -in_memory
set_property include_dirs {/home/tahmeed/Desktop/modifications/FIFO_PROJECT/inc} [current_fileset]
add_files {/home/tahmeed/Desktop/modifications/FIFO_PROJECT/src/fifo_top.sv  /home/tahmeed/Desktop/modifications/FIFO_PROJECT/tst/tb_top.sv}
set_property top fifo_top [current_fileset]
update_compile_order -fileset sources_1
synth_design -top fifo_top -rtl
start_gui
