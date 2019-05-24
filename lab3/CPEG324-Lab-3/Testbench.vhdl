library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

entity calculator_tb is
end entity calculator_tb;

architecture structural of calculator_tb is

component calculator is
  port(
    instr : in std_logic_vector(7 downto 0);
    clk : in std_logic
  );
end component calculator;

signal instr : std_logic_vector(7 downto 0);
signal clk : std_logic;

begin
    calculator_0 : calculator port map(instr, clk);

    process
      file instruction_file : text is in "test.txt";
      variable instruction_line : line;
      variable intruction_vector : bit_vector(7 downto 0);
    begin
      wait for 999 ps;
      while (not(endfile(instruction_file))) loop
        clk <= '0';
        readline(instruction_file, instruction_line); 
        read(instruction_line, intruction_vector); 
        instr <= to_stdlogicvector(intruction_vector);
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
      end loop;
      wait;
    end process;
end architecture structural;
