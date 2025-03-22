# ⏰ FPGA Digital Clock – ELC1119

This repository contains the base code and documentation for a digital clock implemented on an FPGA platform, developed during the first half of the ELC1119 course.

## 📚 Overview

The project implements a 24-hour digital clock using VHDL, running on a Nexys3 FPGA development board. It features timekeeping, alarm functionality, and a dual-mode display interface.

## 🎯 Objectives

- Display the current time in **24-hour format (HH:MM)**
- Include an **alarm system** with configurable trigger time
- Provide **two display modes**:
  - **Time mode**: shows the current time
  - **Alarm config mode**: used to set the alarm time
- **ALARM button**: allows setting the alarm time
- **HOURS button**: allows adjusting the current time

## 🔧 Technologies Used

- **Language**: VHDL
- **Simulation Tools**: GHDL and GTKwave
- **Target Board**: Nexys3 Development Board
- **FPGA**: Xilinx Spartan-6 (XC6LX16 CSG324C)
- **Clock Frequency**: 100 MHz

  

