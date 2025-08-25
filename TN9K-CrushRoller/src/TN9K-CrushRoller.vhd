---------------------------------------------------------------------------------
--                        Crush Roller - Tang Nano 9k
--                             Code from MikeJ
--
--                        Modified for Tang Nano 9k 
--                            by pinballwiz.org 
--                               25/08/2025
---------------------------------------------------------------------------------
-- Keyboard inputs :
--   5 : Add coin
--   2 : Start 2 players
--   1 : Start 1 player
--   RIGHT arrow : Move Right
--   LEFT arrow  : Move Left
--   UP arrow : Move Up
--   DOWN arrow  : Move Down
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
---------------------------------------------------------------------------------
entity crushroller_tn9k is
port(
	Clock_27    : in std_logic;
   	I_RESET     : in std_logic;
	O_VIDEO_R	: out std_logic; 
	O_VIDEO_G	: out std_logic;
	O_VIDEO_B	: out std_logic;
	O_HSYNC		: out std_logic;
	O_VSYNC		: out std_logic;
	O_AUDIO_L 	: out std_logic;
	O_AUDIO_R 	: out std_logic;
   	ps2_clk     : in std_logic;
	ps2_dat     : inout std_logic;
 	led         : out std_logic_vector(5 downto 0) 
 );
end crushroller_tn9k;
------------------------------------------------------------------------------
architecture struct of crushroller_tn9k is

 signal clock_24  : std_logic;
 signal clock_9   : std_logic;
 --
 signal video_r   : std_logic_vector(3 downto 0);
 signal video_g   : std_logic_vector(3 downto 0);
 signal video_b   : std_logic_vector(3 downto 0);
 --
 signal h_sync     : std_logic;
 signal v_sync	   : std_logic;
 --
 signal reset      : std_logic;
 --
 signal kbd_intr        : std_logic;
 signal kbd_scancode    : std_logic_vector(7 downto 0);
 signal joy_BBBBFRLDU   : std_logic_vector(8 downto 0);
 --
 constant CLOCK_FREQ    : integer := 27E6;
 signal counter_clk     : std_logic_vector(25 downto 0);
 signal clock_4hz       : std_logic;
 signal AD              : std_logic_vector(15 downto 0);
---------------------------------------------------------------------------
component Gowin_rPLL
    port (
        clkout: out std_logic;
        clkin: in std_logic
    );
end component;
---------------------------------------------------------------------------
component Gowin_rPLL2
    port (
        clkout: out std_logic;
        clkin: in std_logic
    );
end component;
---------------------------------------------------------------------------
begin

    reset <= not I_RESET;
---------------------------------------------------------------------------
-- Clocks
Clock1: Gowin_rPLL
    port map (
        clkout => clock_24,
        clkin => Clock_27
    );
--
Clock2: Gowin_rPLL2
    port map (
        clkout => Clock_9,
        clkin => Clock_27
    );
---------------------------------------------------------------------------
crushroller : entity work.pacman
  port map (
 CLK_24MHz  => clock_24,
 I_RESET    => reset,
 O_VIDEO_R 	=> video_r,
 O_VIDEO_G 	=> video_g,
 O_VIDEO_B 	=> video_b,
 O_HSYNC    => h_sync,
 O_VSYNC   	=> v_sync,
 O_AUDIO_L  => O_AUDIO_L,
 O_AUDIO_R  => O_AUDIO_R,
 SW_LEFT    => joy_BBBBFRLDU(2),
 SW_RIGHT   => joy_BBBBFRLDU(3),
 SW_UP      => joy_BBBBFRLDU(0),
 SW_DOWN    => joy_BBBBFRLDU(1),
 I_COIN1    => not joy_BBBBFRLDU(7),
 I_1P_START => not joy_BBBBFRLDU(5),
 I_2P_START => not joy_BBBBFRLDU(6),
 AD         => AD
   );
------------------------------------------------------------------------------
-- vga output - using 1bit per color makes some paint colors invisible in game boards

	O_VIDEO_R 	<= video_r(3);
	O_VIDEO_G 	<= video_g(3);
	O_VIDEO_B 	<= video_b(3);
	O_HSYNC     <= h_sync;
	O_VSYNC     <= v_sync;
------------------------------------------------------------------------------
-- get scancode from keyboard

keyboard : entity work.io_ps2_keyboard
port map (
  clk       => clock_9,
  kbd_clk   => ps2_clk,
  kbd_dat   => ps2_dat,
  interrupt => kbd_intr,
  scancode  => kbd_scancode
);
------------------------------------------------------------------------------
-- translate scancode to joystick

joystick : entity work.kbd_joystick
port map (
  clk         => clock_9,
  kbdint      => kbd_intr,
  kbdscancode => std_logic_vector(kbd_scancode), 
  joy_BBBBFRLDU  => joy_BBBBFRLDU 
);
------------------------------------------------------------------------------
-- debug

process(reset, clock_27)
begin
  if reset = '1' then
    clock_4hz <= '0';
    counter_clk <= (others => '0');
  else
    if rising_edge(clock_27) then
      if counter_clk = CLOCK_FREQ/8 then
        counter_clk <= (others => '0');
        clock_4hz <= not clock_4hz;
        led(5 downto 0) <= not AD(9 downto 4);
      else
        counter_clk <= counter_clk + 1;
      end if;
    end if;
  end if;
end process;
------------------------------------------------------------------------
end struct;