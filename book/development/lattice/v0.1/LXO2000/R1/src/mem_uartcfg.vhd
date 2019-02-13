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


entity mem_uartcfg is Port (
    rxdata      : in STD_LOGIC_VECTOR(7 downto 0);
    rxvalid     : in STD_LOGIC;
    clk         : in STD_LOGIC;
    por         : in STD_LOGIC; 

    --
    creset      : out STD_LOGIC;
    cdone       : out STD_LOGIC;
    cclk        : out STD_LOGIC;
    cdo         : out STD_LOGIC
    );
end mem_uartcfg;

architecture Behavioral of mem_uartcfg is

signal sr: std_logic_vector(41 downto 0) := (others => '0'); --

signal rxvalid_s: std_logic_vector(1 downto 0);
signal cclk_s: std_logic;
signal cdone_s: std_logic;

begin
    cclk    <= cclk_s;
    cdone   <= cdone_s;		
    cdo     <= rxdata(0);
    
    
    process (clk, por)
    begin
    if (por = '1') then
        rxvalid_s   <= "00";
        cclk_s      <= '0';
        cdone_s     <= '0';
        creset      <= '1';
    elsif clk'event and clk = '1' then
        rxvalid_s <= rxvalid_s(0) & rxvalid;
        
        -- long reset pulse
        if (rxvalid_s="11") then
            if (rxdata = X"52") then -- "R"
                creset <= '1';
                cdone_s  <= '0';
            else
                creset <= '0';
            end if;

            if (rxdata = X"53") then -- "S"
                cdone_s  <= '1';
            end if;
            
        end if;              
        
        -- only if not done, then send 0, 1 as CCLK pulse
        if ((rxvalid_s="01") and (cdone_s='0')) then
            if (rxdata(7 downto 1) = "0011000") then -- "0" or "1" skip all other chars
                cclk_s <= '1';
            end if;
        else
            cclk_s <= '0';        
        end if;              
        
    end if;
    end process;    
    


end Behavioral;
