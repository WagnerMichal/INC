-- uart.vhd: UART controller - receiving part
-- Author(s): xwagne12 (Wagner Michal)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
ENTITY UART_RX IS
	PORT (
		CLK : IN STD_LOGIC;
		RST : IN STD_LOGIC;
		DIN : IN STD_LOGIC;
		DOUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		DOUT_VLD : OUT STD_LOGIC
	);
END UART_RX;

-------------------------------------------------
ARCHITECTURE behavioral OF UART_RX IS
	SIGNAL counter1 : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL counter2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL recieve_en : STD_LOGIC;
	SIGNAL counter_en : STD_LOGIC;
	SIGNAL DVLD : STD_LOGIC;
BEGIN
	FSM : ENTITY work.UART_FSM(behavioral)
		PORT MAP(
			CLK => CLK,
			RST => RST,
			DIN => DIN,
			CNT1 => counter1,
			CNT2 => counter2,
			RECIEVE_EN => recieve_en,
			COUNTER_EN => counter_en,
			DOUT_VALID => DVLD
		);
	DOUT_VLD <= DVLD;
	PROCESS (CLK) BEGIN
		IF (RST = '1') THEN
			counter1 <= "00000";
			counter2 <= "0000";
		ELSIF rising_edge(CLK) THEN
			IF counter_en = '1' THEN
				counter1 <= counter1 + 1;
			ELSE
				counter1 <= "00000";
				counter2 <= "0000";
			END IF;
			IF recieve_en = '1' AND counter1(4) = '1' THEN
				IF counter1(4) = '1' THEN
					counter1 <= "00000";
					CASE counter2 IS
						WHEN "0000" => DOUT(0) <= DIN;
						WHEN "0001" => DOUT(1) <= DIN;
						WHEN "0010" => DOUT(2) <= DIN;
						WHEN "0011" => DOUT(3) <= DIN;
						WHEN "0100" => DOUT(4) <= DIN;
						WHEN "0101" => DOUT(5) <= DIN;
						WHEN "0110" => DOUT(6) <= DIN;
						WHEN "0111" => DOUT(7) <= DIN;
						WHEN OTHERS => NULL;
					END CASE;
					counter2 <= counter2 + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;
END behavioral;