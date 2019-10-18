# Arty A7-35T UART

### UART Overview

UART stands for Universal Asynchronous Receiver / Transmitter and is used to transmit and receive serial data. The Arty A7 development board includes a shared USB JTAG / UART port to communicate with the connected PC. The entire UART project consists fo two major modules: the reciever and transmitter. 

### UART Receiver

The UART Receiver continuously monitors a given input stream until the first read-bit has been read. This read-bit typically takes the form as the first '0', meaning that the input stream drives a constant '1' when not transmitting data. Once the intial bit has been read, the receiver will prepare to sample the next 8 bits of the input stream. Knowing when to sample the input depends on the pre-defined baud rate of the UART.

The baud rate defines the maximum number of bits that a serial port can transmit per second. For this project, we assume a baud rate of 9600 baud, meaning that a single bit is represented by the input stream approximately every 104us of transmission time. In order for the receiver to sample each bit at the most optimal time of that bit's existence, the sampling will typically occur at the half-way point of a bit's transmission time - approximately 52us for 9600 baud. Thus, once the receiver reads the initial start bit to acknowledge that a bit stream is available, the receiver will continuously sample the serial port every ~52us until 8 bits have been received.

### UART Transmitter


