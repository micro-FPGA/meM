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


entity mem_57110 is Port (
    -- Configuration interface
    cclk        : in STD_LOGIC;
    cdi         : in STD_LOGIC;
    cdo         : out STD_LOGIC;
    creset      : in STD_LOGIC := '0';
    cdone       : in STD_LOGIC := '0';
    --
    done        : out STD_LOGIC; -- embedded Matrix DONE
    
    -- system clock
    clk         : in STD_LOGIC;

    -- We can use BandGap OK as extra input!
    BGOK        : in STD_LOGIC := '1';
    
    ID          : out STD_LOGIC_VECTOR(7 downto 0);
    --
    dbg_I       : out STD_LOGIC_VECTOR(7 downto 0);
    
    P_I         : in STD_LOGIC_VECTOR(7 downto 0);
    P_T         : out STD_LOGIC_VECTOR(7 downto 0);
    P_O         : out STD_LOGIC_VECTOR(7 downto 0)
    );
end mem_57110;

architecture Behavioral of mem_57110 is

attribute DONT_TOUCH : string;

ATTRIBUTE X_INTERFACE_INFO : STRING;

ATTRIBUTE X_INTERFACE_INFO of P_T: SIGNAL is "xilinx.com:interface:gpio:1.0 P TRI_T";
ATTRIBUTE X_INTERFACE_INFO of P_O: SIGNAL is "xilinx.com:interface:gpio:1.0 P TRI_O";
ATTRIBUTE X_INTERFACE_INFO of P_I: SIGNAL is "xilinx.com:interface:gpio:1.0 P TRI_I";

signal lut_en: std_logic;
signal ff_en: std_logic;
signal por: std_logic;


signal cdata: std_logic_vector(9 downto 0);


signal a: std_logic_vector(31 downto 0);
signal q: std_logic_vector(43 downto 0);

attribute DONT_TOUCH of a: signal is "TRUE";
attribute DONT_TOUCH of q: signal is "TRUE";

signal    mode        : STD_LOGIC_VECTOR(8*4-1 downto 0);
signal    rsel        : STD_LOGIC_VECTOR(8*3-1 downto 0);
signal    drive       : STD_LOGIC_VECTOR(8-1 downto 0);

signal port_in: std_logic_vector(7 downto 0);
signal pclk : STD_LOGIC_VECTOR(4 downto 0);
--

begin
    done <= cdone;
    
    lut_en  <= cdone;
    ff_en   <= cdone;
    por     <= creset;

    cdata(9) <= cdi;    

MISC: entity work.mem_misc
     port map (
      cclk          => cclk,
      cdi           => cdata(9),
      cdo           => cdata(8),
      cdone         => cdone,
      ID            => ID,
      pfd_in        => q(37),
      pin2_in       => P_I(0),
      q(1 downto 0) => a(22 downto 21)
    );

IOCONFIG: entity work.mem_ioconfig
     port map (
      mode      => mode,
      rsel      => rsel,
      drive     => drive,
      cclk      => cclk,
      cdi       => cdata(8),
      cdo       => cdata(7)
    );

ACMP: entity work.mem_acmp
     port map (
      cclk          => cclk,
      cdi           => cdata(7),
      cdo           => cdata(6),
      --
      port_in       => port_in,
      pdb           => q(36 downto 35),
      q(1 downto 0) => a(20 downto 19)
    );

CNTDELAY: entity work.mem_cntdelay
     port map (
      a(3 downto 0)     => q(34 downto 31),
      cclk              => cclk,
      pclkin            => pclk,
      por               => por,
      cnt_en            => ff_en,
      
      
      cdi               => cdata(6),
      cdo               => cdata(5),
      q(2 downto 0)     => a(18 downto 16)
    );

OSC: entity work.mem_osc
     port map (
      cclk          => cclk,
      cdi           => cdata(5),
      cdo           => cdata(4),
      clk           => clk,
      osc_en        => ff_en,
      pclkout       => pclk,
      clkout        => a(24 downto 23),
      pin12_in      => P_I(7),
      por           => por
    );

LUT4CNT: entity work.mem_lut4
     port map (
      a(3 downto 0)     => q(30 downto 27),
      cclk              => cclk,
      cdi               => cdata(4),
      cdo               => cdata(3),
      lut_en            => lut_en,
      q                 => a(15)
    );

LUT3FF: entity work.mem_lut3ff
     port map (
      a(14 downto 0)    => q(26 downto 12),
      cclk              => cclk,
      cdi               => cdata(3),
      cdo               => cdata(2),
      ff_en             => ff_en,
      lut_en            => lut_en,
      por               => por,
      q(5 downto 0)     => a(14 downto 9)
    );

LUT2FF: entity work.mem_lut2ff
     port map (
      a(7 downto 0)     => q(11 downto 4),
      cclk              => cclk,
      cdi               => cdata(2),
      cdo               => cdata(1),
      ff_en             => ff_en,
      lut_en            => lut_en,
      por               => por,
      q(3 downto 0)     => a(8 downto 5)
    );

--
-- Matrix fixed input
--
    a(0)    <= '0';
    a(31)   <= '1';


--
-- I/O Ports
--
    -- one vector for all port digital inputs
    port_in <= a(30 downto 27) & a(4 downto 1); 

P2: entity work.mem_io_inp 
    port map (
	   -- from config	
	   mode        => mode(4*0+3 downto 4*0),
	   rsel        => rsel(3*0+2 downto 3*0),
	   
       --
       din         => a(1),
	
	   P_I         => P_I(0),
	   P_O         => P_O(0),
	   P_T         => P_T(0)
    );


P3: entity work.mem_io_reg 
    port map (
	   -- from config	
	   mode        => mode(4*1+3 downto 4*1),
	   rsel        => rsel(3*1+2 downto 3*1),
	   drive       => drive(1),
	   
	   goe         => lut_en,
       --
       din         => a(2),
       dout        => q(0),   
	
	   P_I         => P_I(1),
	   P_O         => P_O(1),
	   P_T         => P_T(1)
    );

P4: entity work.mem_io_reg 
    port map (
	   -- from config	
	   mode        => mode(4*2+3 downto 4*2),
	   rsel        => rsel(3*2+2 downto 3*2),
	   drive       => drive(2),
	   
	   goe         => lut_en,
       --
       din         => a(3),
       dout        => q(1),   
	
	   P_I         => P_I(2),
	   P_O         => P_O(2),
	   P_T         => P_T(2)
    );

P6: entity work.mem_io_oe 
    port map (
	   -- from config	
	   mode        => mode(4*3+3 downto 4*3),
	   rsel        => rsel(3*3+2 downto 3*3),
	   drive       => drive(3),
	   
	   goe         => lut_en,	   
       --
       din         => a(4),
       dout        => q(2),
       oe          => q(3),     
	
	   P_I         => P_I(3),
	   P_O         => P_O(3),
	   P_T         => P_T(3)
    );


P8: entity work.mem_io_reg 
    port map (
	   -- from config	
	   mode        => mode(4*4+3 downto 4*4),
	   rsel        => rsel(3*4+2 downto 3*4),
	   drive       => drive(4),
	   
	   goe         => lut_en,
       --
       din         => a(27),
       dout        => q(39),   
	
	   P_I         => P_I(4),
	   P_O         => P_O(4),
	   P_T         => P_T(4)
    );

P9: entity work.mem_io_reg 
    port map (
	   -- from config	
	   mode        => mode(4*5+3 downto 4*5),
	   rsel        => rsel(3*5+2 downto 3*5),
	   drive       => drive(5),
	   
	   goe         => lut_en,	   
       --
       din         => a(28),
       dout        => q(40),   
	
	   P_I         => P_I(5),
	   P_O         => P_O(5),
	   P_T         => P_T(5)
    );

P10: entity work.mem_io_oe 
    port map (
	   -- from config	
	   mode        => mode(4*6+3 downto 4*6),
	   rsel        => rsel(3*6+2 downto 3*6),
	   drive       => drive(6),
	   
	   goe         => lut_en,	   
       --
       din         => a(29),
       dout        => q(41),
       oe          => q(42),     
	
	   P_I         => P_I(6),
	   P_O         => P_O(6),
	   P_T         => P_T(6)
    );

P12: entity work.mem_io_reg 
    port map (
	   -- from config	
	   mode        => mode(4*7+3 downto 4*7),
	   rsel        => rsel(3*7+2 downto 3*7),
	   drive       => drive(7),
	   
	   goe         => lut_en,	   
       --
       din         => a(30),
       dout        => q(43),
	
	   P_I         => P_I(7),
	   P_O         => P_O(7),
	   P_T         => P_T(7)
    );



MUX: entity work.mux32x44
     port map (
      a(31 downto 0)    => a,
      cclk              => cclk,
      cdi               => cdata(1),
      cdo               => cdata(0),
      q(43 downto 0)    => q
    );

    cdo <= cdata(0);

    --
    dbg_I <= P_I;


end Behavioral;
