-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator is
  port(
    SW0 : in std_logic;
	 SW1 : in std_logic;
	 SW2 : in std_logic;
	 SW3 : in std_logic;
	 SW4 : in std_logic;
	 SW5 : in std_logic;
	 SW6 : in std_logic;
	 SW7 : in std_logic;
    CLK_Button : in std_logic;
	 LED0 : out std_logic;
	 LED1 : out std_logic;
	 LED2 : out std_logic;
	 LED3 : out std_logic;
	 LED4 : out std_logic;
	 LED5 : out std_logic;
	 LED6 : out std_logic;
	 LED7 : out std_logic
  );
end entity calculator;


architecture structural of calculator is
  component ALU is
      port(
          input_a, input_b : in std_logic_vector(7 downto 0);
          addsub_sel : in std_logic;
          sum : out std_logic_vector(7 downto 0)
        );
  end component ALU;

  component reg_file is
    port(
      reg_a : in std_logic_vector(1 downto 0);
      reg_b : in std_logic_vector(1 downto 0);
      reg_write : in std_logic_vector(1 downto 0);
      write_data : in std_logic_vector(7 downto 0);
      clock : in std_logic;
      write_enable : in std_logic;
      reg_a_data : out std_logic_vector(7 downto 0);
      reg_b_data : out std_logic_vector(7 downto 0)
    );
  end component reg_file;

  component clock_filter is
     port (
       clock_input : in std_logic;
       clock_output : out std_logic;
       sig : in std_logic;
       trigger : in std_logic
     );
  end component clock_filter;

signal instr : std_logic_vector(7 downto 0);
signal filtered_clock, write_enable, display, write_data_sel, trigger, skipcount : std_logic;
signal reg_a, reg_b, reg_write : std_logic_vector(1 downto 0);
signal write_data, reg_a_data, reg_b_data, sign_ext, ALU_out: std_logic_vector(7 downto 0);

begin
  instr(0) <= SW0;
  instr(1) <= SW1;
  instr(2) <= SW2;
  instr(3) <= SW3;
  instr(4) <= SW4;
  instr(5) <= SW5;
  instr(6) <= SW6;
  instr(7) <= SW7;
  reg_file_0 : reg_file port map(reg_a, reg_b, reg_write, write_data, filtered_clock, write_enable, reg_a_data, reg_b_data);
  ALU_0 : ALU port map(reg_a_data, reg_b_data, instr(7), ALU_out);
  clock_filter_0 : clock_filter port map(CLK_Button, filtered_clock, instr(4), trigger);

  reg_b <= instr(1 downto 0);
  reg_write <= instr(5 downto 4);

  display <= not(instr(7) or instr(6) or instr(5));

  with display select reg_a <=
    instr(3 downto 2) when '0',
    instr(4 downto 3) when others;

  sign_ext(3 downto 0) <= instr(3 downto 0);
  with instr(3) select sign_ext(7 downto 4) <=
    "1111" when '1',
    "0000" when others;

  write_data_sel <= not(instr(7) and instr(6));
  with write_data_sel select write_data <=
    sign_ext when '0',
    ALU_out when others;

  write_enable <= instr(7) or instr(6);

  trigger <= (not instr(7)) and (not instr(6)) and (not instr(5)) and skipcount;

  skipcount <= (reg_a_data(7) xnor reg_b_data(7)) and
    (reg_a_data(6) xnor reg_b_data(6)) and
    (reg_a_data(5) xnor reg_b_data(5)) and
    (reg_a_data(4) xnor reg_b_data(4)) and
    (reg_a_data(3) xnor reg_b_data(3)) and
    (reg_a_data(2) xnor reg_b_data(2)) and
    (reg_a_data(1) xnor reg_b_data(1)) and
    (reg_a_data(0) xnor reg_b_data(0));

  process(filtered_clock, display) is
    variable int_val : integer;
    begin
      if(rising_edge(filtered_clock)) then
        if(display = '1') then
          int_val := to_integer(signed(reg_a_data));
          if(int_val >= 0) then
            if((int_val / 128) >= 1) then
				  LED7 <= '1';
				  int_val := (int_val - 128);
				end if;
				if((int_val / 64) >= 1) then
				  LED6 <= '1';
				  int_val := (int_val - 64);
				end if;
				if((int_val / 32) >= 1) then
				  LED5 <= '1';
				  int_val := (int_val - 32);
				end if;
				if((int_val / 16) >= 1) then
				  LED4 <= '1';
				  int_val := (int_val - 16);
				end if;
				if((int_val / 8) >= 1) then
				  LED3 <= '1';
				  int_val := (int_val - 8);
				end if;
				if((int_val / 4) >= 1) then
				  LED2 <= '1';
				  int_val := (int_val - 4);
				end if;
				if((int_val / 2) >= 1) then
				  LED1 <= '1';
				  int_val := (int_val - 2);
				end if;
				if((int_val / 1) >= 1) then
				  LED0 <= '1';
				end if;
          else
            LED7 <= '1';
				int_val := (int_val * (-1));
				if((int_val / 64) >= 1) then
				  LED6 <= '1';
				  int_val := (int_val - 64);
				end if;
				if((int_val / 32) >= 1) then
				  LED5 <= '1';
				  int_val := (int_val - 32);
				end if;
				if((int_val / 16) >= 1) then
				  LED4 <= '1';
				  int_val := (int_val - 16);
				end if;
				if((int_val / 8) >= 1) then
				  LED3 <= '1';
				  int_val := (int_val - 8);
				end if;
				if((int_val / 4) >= 1) then
				  LED2 <= '1';
				  int_val := (int_val - 4);
				end if;
				if((int_val / 2) >= 1) then
				  LED1 <= '1';
				  int_val := (int_val - 2);
				end if;
				if((int_val / 1) >= 1) then
				  LED0 <= '1';
				end if;
          end if;
        else
          LED0 <= '0';
			 LED1 <= '0';
			 LED2 <= '0';
			 LED3 <= '0';
			 LED4 <= '0';
			 LED5 <= '0';
			 LED6 <= '0';
			 LED7 <= '0';
        end if;
      end if;
  end process;
end architecture structural;
