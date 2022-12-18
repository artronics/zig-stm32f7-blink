const main = @import("main.zig");

// These symbols come from the linker script
extern const _sidata: u32;
extern var _sdata: u32;
extern const _edata: u32;
extern var _sbss: u32;
extern const _ebss: u32;

export fn resetHandler() void {
    // Copy data from flash to RAM
    const data_loadaddr = @ptrCast([*]const u8, &_sidata);
    const data = @ptrCast([*]u8, &_sdata);
    const data_size = @ptrToInt(&_edata) - @ptrToInt(&_sdata);
    for (data_loadaddr[0..data_size]) |d, i| data[i] = d;

    // Clear the bss
    const bss = @ptrCast([*]u8, &_sbss);
    const bss_size = @ptrToInt(&_ebss) - @ptrToInt(&_sbss);
    for (bss[0..bss_size]) |*b| b.* = 0;

    // Call contained in main.zig
    main.main();

    unreachable;
}
