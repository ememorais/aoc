ghdl --clean
ghdl --remove

ghdl -a "../src/S1C17_register.vhd"
ghdl -e S1C17_register

ghdl -a "../src/s1c17_status_register.vhd"
ghdl -e s1c17_status_register

ghdl -a "../src/s1c17_rom.vhd"
ghdl -e s1c17_rom

ghdl -a "../src/s1c17_register_file.vhd"
ghdl -e s1c17_register_file

ghdl -a "../src/s1c17_alu.vhd"
ghdl -e s1c17_alu

ghdl -a "../src/s1c17_cpu.vhd"
ghdl -e cpu

ghdl -a "../src/s1c17_cpu_tb.vhd"
ghdl -e cpu_tb


ghdl -r cpu_tb --wave="calc.ghw" --stop-time=5000ns
gtkwave calc.ghw calc.gtkw