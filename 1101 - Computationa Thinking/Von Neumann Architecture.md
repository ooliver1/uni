Storing both instructions and data in the same memory.
## Components
- [[#Control unit]]
- [[#Arithmetic-logic unit]]
- [[#Memory unit]]
- [[#Input unit]]
- [[#Output unit]]
## Memory unit
Stores data with an address with the size of the [[#Machine word]]
### Machine word
One unit of data, usually 1 byte.
## Input unit
Give data to the computer. Initially punch cards, now keyboards and scanners.
## Output unit
Displays data to the outside world, now printers and screens.
## Arithmetic-Logic unit
Performs basic operations - +-\*\/ and logic - AND OR NOT < = >, and some registers for small amounts of data.
## Control unit
Performs the [[#FDE Cycle]] with the registers CIR and PC.
## FDE Cycle
Fetch, decode, execute:
- Copy PC to MAR
- Get data at MAR to MDR
- Copy MDR to CIR
- Increment PC
- Decode CIR
- Copy CIR to MAR
- Data into MDR
- Execute
## Buses
- Control
- Data
- Address
Instructions and program data share the data bus, leading to a bottleneck when fetching data.
## GPU
A GPU is made mostly of ALU, and with small amounts of a control unit and DRAM.