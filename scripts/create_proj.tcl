create_project riscv-core ../vivado_project -force -part xc7a100tcsg324-1

set_property -name "enable_vhdl_2008" -value "1" -objects [current_project]
set_property -name "part" -value "xc7a100tcsg324-1" -objects [current_project]

set files [glob ../rtl/*.sv ../rtl/*.v ../rtl/*.vhd]
add_files $files

#set_property top rca_adder32bit [current_fileset]

update_compile_order -fileset sources_1