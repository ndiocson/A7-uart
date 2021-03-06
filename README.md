# Arty A7-35T UART

### UART Overview

UART stands for Universal Asynchronous Receiver/Transmitter and is used to transmit and receive data serially. The Arty A7 development board includes a shared USB JTAG/UART port to communicate with the connected PC. The entire UART project consists of two major modules: the receiver and transmitter. 

![UART Simulation between UART_Rx and UART_Tx for 9600 baud](https://github.com/ndiocson/fpga-uart/blob/master/pictures/UART_Simulation_1.JPG)

The default baud rate assumed for this UART implementation is 9600 baud, but can be modified.

### UART Receiver

The UART Receiver continuously monitors a given input stream until the first read bit has been read. This read bit typically takes the form as the first '0', meaning that the input stream drives a constant '1' when not transmitting data. Once the initial bit has been read, the receiver will prepare to sample the next N-bits of the input stream. Knowing when to sample the input depends on the pre-defined baud rate of the UART. Once all of the transmission bits have been sent, the final stop bit is read from the input stream to indicate the end of transmission.

### UART Transmitter

The UART Transmitter will transmit a given N-bit input vector to the output stream according to the bit pattern mentioned above. When the 'transmit' signal is asserted, the transmitter will pull down the output stream to indicate the start of the transmission. Next, the N transmission bits are sent to the output stream, with each bit being held for the necessary amount of time based on the baud rate. Finally, the output stream is pull back up to indicate the end of the transmission.
