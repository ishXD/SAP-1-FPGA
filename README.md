# SAP-1-FPGA
SAP-1 : 8 bit FPGA computer implemented using AMD vivado

## OVERVIEW

Here is the overview of the SAP-1 computer:
![overview](https://github.com/ishXD/SAP-1-FPGA/blob/main/images/sap1.png)
<br><br>
## SIMULATION

Here are all the relevant signals:

![](https://github.com/ishXD/SAP-1-FPGA/blob/main/images/Screenshot%202024-07-05%20172401.png)

Here is the annotated test program (program.bin):
```
$0 |   0D  // LDA [$D]   Load A with the value at address $D
$1 |   1E  // ADD [$E]   Add the value at address $E to A
$2 |   2F  // SUB [$F]   Subtract the value at address $F from A
$3 |   F0  // HLT        Stop execution
$4 |   00
$5 |   00
$6 |   00
$7 |   00
$8 |   00 
$9 |   00 
$A |   00 
$B |   00
$C |   00
$D |   03  // Data: 3
$E |   04  // Data: 4
$F |   02  // Data: 2
```
The yellow signals show the values of reg_a and reg_b 
You can see the values of reg_a changing to 3 + 4 - 2 = 5 and then then hlt signal causes the clk to stop ticking.
