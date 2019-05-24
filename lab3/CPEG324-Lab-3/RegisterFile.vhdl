library ieee;
use ieee.std_logic_1164.all;

entity reg_file is
  port(
    reg_a : in std_logic_vector(1 downto 0);
    reg_b : in std_logic_vector(1 downto 0);
    reg_write : in std_logic_vector(1 downto 0);
    write_data : in std_logic_vector(7 downto 0);
    clk : in std_logic;
    write_enable : in std_logic;
    reg_a_data : out std_logic_vector(7 downto 0);
    reg_b_data : out std_logic_vector(7 downto 0)
  );
end entity reg_file;

architecture behavioral of reg_file is
  signal R0 : std_logic_vector(7 downto 0) := "00000000";
  signal R1 : std_logic_vector(7 downto 0) := "00000000";
  signal R2 : std_logic_vector(7 downto 0) := "00000000";
  signal R3 : std_logic_vector(7 downto 0) := "00000000";

  begin
    with reg_a select reg_a_data <=
      R0 when "00",
      R1 when "01",
      R2 when "10",
      R3 when others;
    with reg_b select reg_b_data <=
      R0 when "00",
      R1 when "01",
      R2 when "10",
      R3 when others;

    process (clk) is
      begin
        if (clk'event and clk='1') then
          if (write_enable = '1') then
            if (reg_write = "00") then
              R0 <= write_data;
            elsif (reg_write = "01") then
              R1 <= write_data;
            elsif (reg_write = "10") then
              R2 <= write_data;
            elsif (reg_write = "11") then
              R3 <= write_data;
            end if;
          end if;
        end if;
   end process;
end architecture;
