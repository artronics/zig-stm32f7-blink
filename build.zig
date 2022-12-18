const std = @import("std");
const Target = std.Target;
const CrossTarget = std.zig.CrossTarget;

pub fn build(b: *std.build.Builder) void {
    const target = CrossTarget{
        .cpu_arch = Target.Cpu.Arch.thumb,
        // .cpu_model = .{.explicit = &cpu_model},
        .cpu_model = .{ .explicit = &Target.arm.cpu.cortex_m7 },
        .os_tag = Target.Os.Tag.freestanding,
        .abi = Target.Abi.eabi,
    };
    const mode = b.standardReleaseOptions();

    const elf = b.addExecutable("zig-stm32f7-blink.elf", "src/startup.zig");
    b.default_step.dependOn(&elf.step);

    const vector_obj = b.addObject("vector", "src/vector.zig");
    vector_obj.setTarget(target);
    vector_obj.setBuildMode(mode);
    elf.addObject(vector_obj);

    elf.setTarget(target);
    elf.setBuildMode(mode);

    elf.setLinkerScriptPath(.{ .path = "data/STM32F767.ld" });
    elf.addAssemblyFile("src/startup_stm32f767xx.s");

    elf.install();

    const bin = b.addInstallRaw(elf, "zig-stm32f7-blink.bin", .{});
    const bin_step = b.step("bin", "Generate binary file to be flashed");
    bin_step.dependOn(&bin.step);

    const openocd_scripts_path = "/opt/homebrew/share/openocd/scripts";
    const openocd_board = thisDir() ++ "/data/st_nucleo_f7.cfg";

    // TODO: use build api to get the path
    const elf_path = thisDir() ++ "zig-out/bin/zig-stm32f7-blink.bin";
    // const elf_path = "/Users/jalal/projects/embedded/arm/nucleo-f7-example/build/nucleo-f7-example.elf";
    // std.log.debug("path {s}", b.getInstallPath());

    // zig fmt: off
    const flash_cmd = b.addSystemCommand(&[_][]const u8{
        "openocd",
        "-s", openocd_scripts_path,
        "-f", openocd_board,

        "-c", "gdb_port disabled", "-c", "tcl_port disabled",
        // "-c", b.fmt("program {s}", .{b.getInstallPath(bin.dest_dir, bin.dest_filename)}),
        "-c", b.fmt("program {s}", .{elf_path}),
        "-c", "reset", "-c", "shutdown"
    });
    // zig fmt: on

    flash_cmd.step.dependOn(&bin.step);
    flash_cmd.step.dependOn(&elf.step);
    const flash_step = b.step("flash", "Flash and run the app.");
    flash_step.dependOn(&flash_cmd.step);


    const run_cmd = elf.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_tests = b.addTest("src/main.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}
