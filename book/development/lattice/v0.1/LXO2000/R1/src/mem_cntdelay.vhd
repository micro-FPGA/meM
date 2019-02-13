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


entity mem_cntdelay is Port (
    a           : in STD_LOGIC_VECTOR(3 downto 0);
    q           : out STD_LOGIC_VECTOR(2 downto 0);
    
    pclkin      : in STD_LOGIC_VECTOR(4 downto 0);

    por         : in STD_LOGIC; 
    cnt_en      : in STD_LOGIC; -- enable
    --
    cclk        : in STD_LOGIC;
    cdi         : in STD_LOGIC;
    cdo         : out STD_LOGIC
    );
end mem_cntdelay;

architecture Behavioral of mem_cntdelay is

signal sr: std_logic_vector(41 downto 0) := (others => '0'); --

signal cnt0: unsigned(7 downto 0) := X"00"; --
signal cnt1: unsigned(7 downto 0) := X"00"; --
signal cnt3: unsigned(7 downto 0) := X"00"; --

signal clk0: std_logic := '0'; --
signal clk1: std_logic := '0'; --
signal clk3: std_logic := '0'; --

signal clk0m: std_logic := '0'; --
signal clk1m: std_logic := '0'; --
signal clk3m: std_logic := '0'; --

signal cnt0_ov: std_logic; --
signal cnt1_ov: std_logic; --
signal cnt2_ov: std_logic; --
signal cnt3_ov: std_logic; --


signal cfg_tc0: std_logic_vector(7 downto 0); --
signal cfg_tc1: std_logic_vector(7 downto 0); --
signal cfg_tc3: std_logic_vector(7 downto 0); --

signal cfg_mode0: std_logic; --
signal cfg_mode1: std_logic; --
signal cfg_mode3: std_logic; --

signal cfg_sel0: std_logic_vector(2 downto 0); --
signal cfg_sel1: std_logic_vector(2 downto 0); --
signal cfg_sel3: std_logic_vector(2 downto 0); --

signal cfg_msel0: std_logic_vector(1 downto 0); --
signal cfg_msel1: std_logic_vector(1 downto 0); --
signal cfg_msel3: std_logic_vector(1 downto 0); --

begin
    cfg_mode0 <= sr(0);
    cfg_sel0  <= sr(3 downto 1);
    cfg_tc0   <= sr(11 downto 4);
    cfg_msel0 <= sr(13 downto 12);
    
    cfg_mode1 <= sr(14+0);
    cfg_sel1  <= sr(14+3 downto 14+1);
    cfg_tc1   <= sr(14+11 downto 14+4);
    cfg_msel1 <= sr(14+13 downto 14+12);
    
    cfg_mode3 <= sr(28+0);
    cfg_sel3  <= sr(28+3 downto 28+1);
    cfg_tc3   <= sr(28+11 downto 28+4);
    cfg_msel3 <= sr(28+13 downto 28+12);
    
    clk0m <=
        pclkin(1) when cfg_sel0="001" else
        pclkin(2) when cfg_sel0="010" else
        pclkin(3) when cfg_sel0="011" else
        pclkin(4) when cfg_sel0="100" else
        a(2)      when cfg_sel0="100" else -- EXTERN clock from Matrix 33
        a(2)      when cfg_sel0="110" else -- EXTERN clock from Matrix 33
        cnt3_ov   when cfg_sel0="111" else -- overflow cnt3
        pclkin(0); -- 
    
    clk1m <=
            pclkin(1) when cfg_sel1="001" else
            pclkin(2) when cfg_sel1="010" else
            pclkin(3) when cfg_sel1="011" else
            pclkin(4) when cfg_sel1="100" else
            a(2)      when cfg_sel1="100" else -- EXTERN clock from Matrix 33
            a(2)      when cfg_sel1="110" else -- EXTERN clock from Matrix 33
            cnt0_ov   when cfg_sel1="111" else -- overflow cnt0
            pclkin(0); -- 
    
    clk3m <=
                    pclkin(1) when cfg_sel3="001" else
                    pclkin(2) when cfg_sel3="010" else
                    pclkin(3) when cfg_sel3="011" else
                    pclkin(4) when cfg_sel3="100" else
                    a(3)      when cfg_sel3="100" else -- EXTERN clock from Matrix 34 shared
                    a(3)      when cfg_sel3="110" else -- EXTERN clock from Matrix 34 shared
                    cnt2_ov   when cfg_sel3="111" else -- overflow cnt2 -  from external cnt module !!
                    pclkin(0); -- 
    
    -- needed for simulation 0 delay oscillation..
    clk0 <= clk0m and cnt_en;
    clk1 <= clk1m and cnt_en;
    clk3 <= clk3m and cnt_en;
    
    process (clk0, por)
    begin
    if (por = '1') then
            cnt0 <= unsigned(cfg_tc0);
            cnt0_ov <= '1';
    elsif clk0'event and clk0 = '1' then
        if (cnt_en='1') then
            if (cnt0 = 0) then
                cnt0 <= unsigned(cfg_tc0);
                cnt0_ov <= '1';
            else
                cnt0 <= cnt0 - 1;
                cnt0_ov <= '0';
            end if;
        end if;              
    end if;
    end process;    
    
    process (clk1, por)
    begin
    if (por = '1') then
            cnt1 <= unsigned(cfg_tc1);
            cnt1_ov <= '1';
    elsif clk1'event and clk1 = '1' then
        if (cnt_en='1') then
            if (cnt1 = 0) then
                cnt1 <= unsigned(cfg_tc1);
                cnt1_ov <= '1';
            else
                cnt1 <= cnt1 - 1;
                cnt1_ov <= '0';
            end if;
        end if;              
    end if;
    end process;    

    process (clk3, por)
    begin
    if (por = '1') then
            cnt3 <= unsigned(cfg_tc3);
            cnt3_ov <= '1';
    elsif clk3'event and clk3 = '1' then
        if (cnt_en='1') then
            if (cnt3 = 0) then
                cnt3 <= unsigned(cfg_tc3);
                cnt3_ov <= '1';
            else
                cnt3 <= cnt3 - 1;
                cnt3_ov <= '0';
            end if;
        end if;              
    end if;
    end process;    

    
    q(0) <= cnt0_ov;
    q(1) <= cnt1_ov;
    q(2) <= cnt3_ov;
 
    
    cdo <= sr(0);
      
  	process (cclk)
	begin
        if cclk'event and cclk = '1' then
           sr(41 downto 0) <= cdi & sr (41 downto 1); 
        end if;
	end process;


end Behavioral;
