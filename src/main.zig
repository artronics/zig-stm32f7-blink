// export fn Reset_Handler() void {

// }

export fn main() u32 {
    return 0;
}

export fn SystemInit() callconv(.C) void {
    
}

export fn HardFault_Handler() callconv(.C) void {
    while(true){}
}

export fn __libc_init_array() callconv(.C) void {}

const std = @import("std");
test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
