const stm32f767 = @import("stm32f767_registers.zig");
const regs = stm32f767.registers;
export fn main() u32 {
    systemInit();

    // Enable GPIOD port
    // while (true) {}
    regs.RCC.AHB1ENR.modify(.{ .GPIOBEN = 1 });

    // Set pin 0/7 mode to general purpose output
    regs.GPIOB.MODER.modify(.{ .MODER0 = 0b01, .MODER7 = 0b01 });

    // Set pin 0 and 7
    regs.GPIOB.BSRR.modify(.{ .BS0 = 1, .BS7 = 1 });

    while (true) {}

    return 0;
}

fn systemInit() void {
    // TODO: enable FPU # SCB->CPACR |= ((3UL << 10*2)|(3UL << 11*2));

    //spell-checker: disable
    regs.RCC.APB1ENR.modify(.{ .PWREN = 0b1 });
    while (regs.RCC.APB1ENR.read().PWREN != 1) {}

    // Enable HSI
    // regs.RCC.CR.modify(.{ .HSION = 1 });

    // Wait for HSI ready
    // while (regs.RCC.CR.read().HSIRDY != 1) {}

    // Select HSI as clock source
    // regs.RCC.CFGR.modify(.{ .SW0 = 0, .SW1 = 0 });

    // Enable external high-speed oscillator (HSE)
    regs.RCC.CR.modify(.{ .HSEON = 1 });

    // Wait for HSE ready
    while (regs.RCC.CR.read().HSERDY != 1) {}

    // Set prescalers for 96 MHz: HPRE = 0, PPRE1 = DIV_2, PPRE2 = DIV_1
    regs.RCC.CFGR.modify(.{ .HPRE = 0, .PPRE1 = 0b100, .PPRE2 = 0b000 });

    // Disable PLL before changing its configuration
    regs.RCC.CR.modify(.{ .PLLON = 0 });

    // Set PLL prescalers and HSE clock source
    regs.RCC.PLLCFGR.modify(.{
        .PLLSRC = 1,
        // PLLM = 4 = 0b000100
        .PLLM0 = 0,
        .PLLM1 = 0,
        .PLLM2 = 1,
        .PLLM3 = 0,
        .PLLM4 = 0,
        .PLLM5 = 0,
        // PLLN = 96 = 0b0110_0000
        .PLLN0 = 0,
        .PLLN1 = 0,
        .PLLN2 = 0,
        .PLLN3 = 0,
        .PLLN4 = 0,
        .PLLN5 = 0,
        .PLLN6 = 1,
        .PLLN7 = 1,
        .PLLN8 = 0,
        // PLLP = 2 = 0b10
        
        .PLLP0 = 0,
        .PLLP1 = 1,
        // PLLQ = 4 = 0b100
        .PLLQ0 = 0,
        .PLLQ1 = 0,
        .PLLQ2 = 1,
    });

    // Enable PLL
    regs.RCC.CR.modify(.{ .PLLON = 1 });

    // Wait for PLL ready
    while (regs.RCC.CR.read().PLLRDY != 1) {}

    // Enable flash data and instruction cache and set flash latency to 5 wait states
    regs.Flash.ACR.modify(.{ .PRFTEN = 1, .LATENCY = 5 });

    // Select PLL as clock source
    regs.RCC.CFGR.modify(.{ .SW1 = 1, .SW0 = 0 });

    // Wait for PLL selected as clock source
    var cfgr = regs.RCC.CFGR.read();
    while (cfgr.SWS1 != 1 and cfgr.SWS0 != 0) : (cfgr = regs.RCC.CFGR.read()) {}

    // Disable HSI
    regs.RCC.CR.modify(.{ .HSION = 0 });
    //spell-checker: enable
}

export fn UsageFault_Handler() void {
    while (true) {}
}
export fn BusFault_Handler() void {
    while (true) {}
}
export fn MemManage_Handler() void {
    while (true) {}
}
export fn HardFault_Handler() void {
    while (true) {}
}

const std = @import("std");
test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
