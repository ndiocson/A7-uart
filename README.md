# Arty A7-35T UART

### UART Overview

UART stands for Universal Asynchronous Receiver / Transmitter and is used to transmit and receive serial data. The Arty A7 development board includes a shared USB JTAG / UART port to communicate with the connected PC. The entire UART project consists fo two major modules: the reciever and transmitter. 

The default baud rate assumed for this UART implementation is 9600 baud, allowing for approximately ~104us to represent a full bit and ~52us to sample a bit.

![UART Simulation between UART_Rx and UART_Tx for 9600 baud](https://github.com/ndiocson/fpga-uart/blob/master/pictures/UART_Simulation_1.JPG)

### UART Receiver

The UART Receiver continuously monitors a given input stream until the first read-bit has been read. This read-bit typically takes the form as the first '0', meaning that the input stream drives a constant '1' when not transmitting data. Once the intial bit has been read, the receiver will prepare to sample the next N-bits of the input stream. Knowing when to sample the input depends on the pre-defined baud rate of the UART. Once all of the transmission bits have been sent, the final stop bit is read from the input stream to indicate the end of transmission.

### UART Transceiver

The UART Transceiver will transmit a given N-bit input vector to the output stream according to the bit pattern mentioned above. When the 'transmit' signal is asserted, the transceiver will pull down the output stream to indicate the start of the transmission. Next, the N transmission bits are sent to the output stream, with each bit being held for the necessary amount of time based on the baud rate. Finally, the output stream is pull back up to indicate the end of the transmission.
