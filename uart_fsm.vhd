-- uart_fsm.vhd: UART controller - finite state machine
-- Author(s): xwagne12 (Wagner Michal)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-------------------------------------------------
ENTITY UART_FSM IS
   PORT (
      CLK : IN STD_LOGIC;
      RST : IN STD_LOGIC;
      DIN : IN STD_LOGIC;
      CNT1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      CNT2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      RECIEVE_EN : OUT STD_LOGIC;
      COUNTER_EN : OUT STD_LOGIC;
      DOUT_VALID : OUT STD_LOGIC
   );
END ENTITY UART_FSM;

-------------------------------------------------
ARCHITECTURE behavioral OF UART_FSM IS
   TYPE STATE_TYPE IS (WAIT_START_BIT, WAIT_FIRST_BIT, RECIEVE_DATA, WAIT_STOP_BIT, DATA_VALID);
   SIGNAL state : STATE_TYPE := WAIT_START_BIT;
BEGIN
   RECIEVE_EN <= '1' WHEN state = RECIEVE_DATA ELSE
      '0';
   COUNTER_EN <= '1' WHEN state = WAIT_FIRST_BIT OR state = RECIEVE_DATA ELSE
      '0';
   DOUT_VALID <= '1' WHEN state = DATA_VALID ELSE
      '0';
   PROCESS (CLK) BEGIN
      IF rising_edge(CLK) THEN
         IF RST = '1' THEN
            state <= WAIT_START_BIT;
         ELSE
            CASE state IS
               WHEN WAIT_START_BIT => IF DIN = '0' THEN
                  state <= WAIT_FIRST_BIT;
            END IF;
            WHEN WAIT_FIRST_BIT => IF CNT1 = "10000" THEN
            state <= RECIEVE_DATA;
         END IF;
         WHEN RECIEVE_DATA => IF CNT1 = "10000" THEN
         IF CNT2 = "1000" THEN
            state <= WAIT_STOP_BIT;
         END IF;
      END IF;
      WHEN WAIT_STOP_BIT => IF DIN = '1' THEN
      state <= DATA_VALID;
   END IF;
   WHEN DATA_VALID => state <= WAIT_START_BIT;
   WHEN OTHERS => NULL;
END CASE;
END IF;
END IF;
END PROCESS;
END behavioral;