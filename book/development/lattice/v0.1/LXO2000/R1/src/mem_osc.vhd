----------------------------------------------------------------------------------
-- Company: MicroFPGA UG
-- Engineer: Antti Lukats
-- 
-- Create Date: 12.01.2019
-- Design Name: 
-- Module Name: 
-- Project Name: meM "micro embeded Matrix"  
--               https://github.com/micro-FPGA/mEM
-- Target Devices: any
-- Tool Versions: any
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: 
--  mEM project was born when writing a book "Electronics? Simple! Again :)"
--  https://github.com/micro-FPGA/esa
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity mem_osc is Port (
    cclk        : in STD_LOGIC;
    cdi         : in STD_LOGIC;
    cdo         : out STD_LOGIC;
    
    por         : in STD_LOGIC := '0';
    
    osc_en      : in STD_LOGIC := '0';
    --
    clk         : in STD_LOGIC;
    pclkout     : out STD_LOGIC_VECTOR(4 downto 0);
    pin12_in    : in STD_LOGIC;
    --
    clkout      : out STD_LOGIC_VECTOR(1 downto 0)
    );
end mem_osc;

architecture Behavioral of mem_osc is

signal rc_prescaler: unsigned(6 downto 0) := "0000000"; --

signal prescaler: unsigned(2 downto 0) := "000"; --
signal clk_div: unsigned(5 downto 0) := "000000"; --

signal pclk: std_logic; -- pre scaled clock

signal rc_clk: std_logic; -- 2MHz or 25KHz
signal rc_clk_25K: std_logic; 


signal sr: std_logic_vector(11 downto 0); -- 


signal cfg_pre: std_logic_vector(1 downto 0); --
signal cfg_out0: std_logic_vector(2 downto 0); --
signal cfg_out1: std_logic_vector(2 downto 0); --


begin
    pclkout(0) <= pclk; -- 
    pclkout(1) <= clk_div(1); -- div 4
    pclkout(2) <= clk_div(3); -- div 12   16 
    pclkout(3) <= clk_div(4); -- div 24   32
    pclkout(4) <= clk_div(5); -- div 64
    
    
    cfg_pre  <= sr(3 downto 2);
    cfg_out0 <= sr(6 downto 4);
    cfg_out1 <= sr(9 downto 7);


    process (clk)
    begin
      if clk'event and clk = '1' then
         rc_prescaler <= rc_prescaler + 1; 
      end if;
    end process;
    rc_clk_25K <= rc_prescaler(5); -- divide by 64 (should be 80)

    rc_clk <= 
        (clk and osc_en) when sr(1) = '1' else
        (rc_clk_25K and osc_en);



    -- TODO prescaler reset and proper start sequence after config done..
    process (rc_clk)
    begin
      if rc_clk'event and rc_clk = '1' then
         prescaler <= prescaler + 1; 
      end if;
    end process;
    
    -- not nice way to switch clocks!
    pclk <= 
        prescaler(0) when cfg_pre="01" else -- divide by 2
        prescaler(1) when cfg_pre="10" else -- divide by 4
        prescaler(2) when cfg_pre="11" else -- divide by 8 
        rc_clk; -- divide by 1
    
    process (pclk)
    begin
       if pclk'event and pclk = '1' then
          clk_div <= clk_div + 1; 
       end if;
    end process;
    
    -- TODO divide by 3, 12, 24
    clkout(0) <= 
        clk_div(0) when cfg_out0="001" else -- divide by 2
            clk_div(0) when cfg_out0="010" else -- divide by 3 --- 2
        clk_div(1) when cfg_out0="011" else -- divide by 4
        clk_div(2) when cfg_out0="100" else -- divide by 8
            clk_div(3) when cfg_out0="101" else -- divide by 12 --- 16 !!!
            clk_div(4) when cfg_out0="110" else -- divide by 24 --- 32 !!!
        clk_div(5) when cfg_out0="111" else -- divide by 8
        pclk; -- divide by 1
    
    clkout(1) <= 
            clk_div(0) when cfg_out1="001" else -- divide by 2
                clk_div(0) when cfg_out1="010" else -- divide by 3 --- 2
            clk_div(1) when cfg_out1="011" else -- divide by 4
            clk_div(2) when cfg_out1="100" else -- divide by 8
                clk_div(3) when cfg_out1="101" else -- divide by 12 --- 16 !!!
                clk_div(4) when cfg_out1="110" else -- divide by 24 --- 32 !!!
            clk_div(5) when cfg_out1="111" else -- divide by 8
            pclk; -- divide by 1
    
    
    --
    -- Config
    --  
  	process (cclk)
	begin
        if cclk'event and cclk = '1' then
           sr(11 downto 0) <= cdi & sr (11 downto 1); 
        end if;
	end process;
    cdo <= sr(0);

end Behavioral;
