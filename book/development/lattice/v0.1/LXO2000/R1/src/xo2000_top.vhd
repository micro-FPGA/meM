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


entity xo2000_top is Port (
    -- system clock
    clk         : in STD_LOGIC;
    rstn        : in STD_LOGIC;

    UART_rxd    : in STD_LOGIC;
    UART_txd    : inout STD_LOGIC;

	USER_BUTTON : in STD_LOGIC;
    USER_LED    : out STD_LOGIC; 
    LEDS        : out STD_LOGIC_VECTOR(7 downto 0);

    
    P           : inout STD_LOGIC_VECTOR(7 downto 0)
    );
end xo2000_top;

architecture Behavioral of xo2000_top is

signal P_I: std_logic_vector(7 downto 0);
signal P_O: std_logic_vector(7 downto 0);
signal P_T: std_logic_vector(7 downto 0);

begin
  P_I(7 downto 1) <= P(7 downto 1);
  P_I(0) <= USER_BUTTON;
  
  P(0) <= P_O(0) when P_T(0) = '0' else 'Z';
  P(1) <= P_O(1) when P_T(1) = '0' else 'Z';
  P(2) <= P_O(2) when P_T(2) = '0' else 'Z';
  P(3) <= P_O(3) when P_T(3) = '0' else 'Z';

  P(4) <= P_O(4) when P_T(4) = '0' else 'Z';
  P(5) <= P_O(5) when P_T(5) = '0' else 'Z';
  P(6) <= P_O(6) when P_T(6) = '0' else 'Z';
  P(7) <= P_O(7) when P_T(7) = '0' else 'Z';

  LEDS <= P_O;

  U0 : entity work.mkr_top
    PORT MAP (
      clk 	=> clk,
      rstn 	=> rstn,
      UART_rxd 	=> UART_rxd,
      UART_txd 	=> UART_txd,
      USER_LED 	=> USER_LED,
      LEDS 	=> open, --LEDS,
      P_I 	=> P_I,
      P_T 	=> P_T,
      P_O 	=> P_O
    );

end Behavioral;
