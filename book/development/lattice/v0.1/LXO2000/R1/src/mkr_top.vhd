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


entity mkr_top is Port (
    -- system clock
    clk         : in STD_LOGIC;
    rstn        : in STD_LOGIC;

    UART_rxd    : in STD_LOGIC;
    UART_txd    : out STD_LOGIC;

    USER_LED    : out STD_LOGIC; 
    LEDS        : out STD_LOGIC_VECTOR(7 downto 0);

    
    P_I         : in STD_LOGIC_VECTOR(7 downto 0);
    P_T         : out STD_LOGIC_VECTOR(7 downto 0);
    P_O         : out STD_LOGIC_VECTOR(7 downto 0)
    );
end mkr_top;

architecture Behavioral of mkr_top is

  component baudgen is
  port (
    clk : in STD_LOGIC;
    tick : out STD_LOGIC
  );
  end component baudgen;
  
  component rx is
  port (
    res_n : in STD_LOGIC;
    rx : in STD_LOGIC;
    clk : in STD_LOGIC;
    rx_byte : out STD_LOGIC_VECTOR ( 7 downto 0 );
    rdy : out STD_LOGIC
  );
  end component rx;


attribute DONT_TOUCH : string;

ATTRIBUTE X_INTERFACE_INFO : STRING;

ATTRIBUTE X_INTERFACE_INFO of P_T: SIGNAL is "xilinx.com:interface:gpio:1.0 P TRI_T";
ATTRIBUTE X_INTERFACE_INFO of P_O: SIGNAL is "xilinx.com:interface:gpio:1.0 P TRI_O";
ATTRIBUTE X_INTERFACE_INFO of P_I: SIGNAL is "xilinx.com:interface:gpio:1.0 P TRI_I";


signal cclk: std_logic;
signal cdone: std_logic;
signal creset: std_logic;
signal cdata: std_logic;

signal mclk: std_logic;

signal baudtick: std_logic; -- baudrate tick
signal rx_rdy: std_logic; -- 
signal rx_data: std_logic_vector(7 downto 0); --

signal por: std_logic; --

begin
    UART_txd <= UART_rxd;
    
    por <= not rstn;

baudgen_inst: component baudgen
     port map (
      clk   => clk,
      tick  => baudtick
    );

rx_inst: component rx
     port map (
      clk       => baudtick,
      rdy       => rx_rdy,
      res_n     => rstn,
      rx        => UART_rxd,
      rx_byte   => rx_data
    );
--
--
--
uartcfg: entity work.mem_uartcfg
     port map (
      cclk      => cclk,
      cdo       => cdata,
      cdone     => cdone,
      clk       => mclk,
      creset    => creset,
      por       => por,
      rxdata(7 downto 0) => rx_data(7 downto 0),
      rxvalid => rx_rdy
    );

--
-- clock divider may depend on the board!
--
rclk_div: entity work.rclk_div
     port map (
      clk       => clk,
      divout    => mclk
    );

--
-- meM micro embedded Matrix
--
mEM57110: entity work.mem_57110
     port map (
      BGOK => '1',
      ID(7 downto 0) => LEDS,
      P_I(7 downto 0) => P_I(7 downto 0),
      P_O(7 downto 0) => P_O(7 downto 0),
      P_T(7 downto 0) => P_T(7 downto 0),
      cclk => cclk,
      cdi => cdata,
      cdo => open,
      cdone => cdone,
      clk => mclk,
      creset => creset,
      dbg_I => open,
      done => USER_LED
    );


end Behavioral;
