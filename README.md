### Project
A blinking LED project using the Zig programming language. With the use of OpenOCD, you can program the chip and debug your project using the provided Visual Studio Code configurations. These configurations include both launch and task configurations, allowing you to run and test your code.

### Building the project
To build and program the board run:
```
zig build flash
```

### Setup
This project is using NUCLEO-F767ZI board but, if you have a different board, you can still use these instructions to create your own project. Simply follow the steps outlined below to build and program your board:

#### Dependencies:
- Zig programming language
- `arm-none-eabi` toolchain. We use Zig to cross-compile our code, but the toolchain comes with other useful tools including `gdb`.
- OpenOCD to program the chip and running debugger server
- STM32CubeMX to generate the startup and linker files

#### Steps
- Use STM32CubeMX program to generator a project.
- Copy the `startup_<chip>.s` and `<ship>.ld` files.
- Download the chip's `SVD` file from ST website. 
    - Use (regz)[https://github.com/ZigEmbeddedGroup/regz] project from zig-embedded team to generate a registers file.
    - This step is optional. The debugger settings in the `launch.json` references this file. This will allow you to search for registers by name and check their values during debugging.


### Credits:
I used source code from:
- https://github.com/rbino/zig-stm32-blink