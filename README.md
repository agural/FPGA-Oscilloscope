FPGA-Oscilloscope
=================

This repository contains all files related to the design and creation of my FPGA Oscilloscope.
The oscilloscope is based on the Altera Cyclone III EPC340 FPGA as part of my Caltech EE 052 class project.

Included documents:
-------------------
    - Documentation
        - Functional Specification
        - System Block Diagram
        - Planned Board Layout
        - Memory Map
        - Cyclone III Pinout
    - Circuit
        - Schematic Diagram
        - Board Layout
    - Code
        - Quartus FPGA Code
        - NIOS Program Code

Oscilloscope Capabilities:
--------------------------
 1. Sample Rates
    1. 10, 20, 50, 100, 200, 500 ns
    2. 1, 2, 5, 10, 20, 50, 100, 200, 500 us
    3. 1, 2, 5, 10, 20, 50, 100, 200, 500 ms
 1. Vertical Sensitivities
    1. 1, 2, 5, 10, 20, 50, 100, 200, 500 mV
    1. 1, 2, 5 V
 1. Sample Resolution
    1. Channel A/B: 8 bits
    1. Logic Analyzer: 1 bit per channel (high-threshold at 1.0V)
 1. Input Voltage Range: -10V to 10V
 1. Trigger Level Resolution: Channel A/B is 7 bits; Logic Analyzer is one for each bit
 1. Trigger Slope: Positive or Negative
 1. Trigger Delay: -10,000 samples / +50,000 samples
