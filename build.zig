const std = @import("std");

pub fn build(b: *std.Build) void {
    const is_wasm = b.option(bool, "target-web", "build wasm") orelse false;
    // build_config
    const options = b.addOptions();
    options.addOption(bool, "web_build", is_wasm);
    if (is_wasm) {
        build_web(b, options);
    } else {
        build_exe(b, options);
    }
}

pub fn build_web(b: *std.Build, opts: *std.Build.Step.Options) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .wasm32,
        .os_tag = .freestanding,
    });

    const exe = b.addExecutable(.{
        .name = "zig-opengl-glfw-wasm",
        .root_source_file = b.path("src/main_web.zig"),
        .target = target,
        .optimize = .ReleaseSmall,
    });
    exe.entry = .disabled;
    exe.rdynamic = true;
    exe.root_module.addOptions("config", opts);

    b.installArtifact(exe);
}

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build_exe(b: *std.Build, opts: *std.Build.Step.Options) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zig-opengl-glfw-wasm",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addOptions("config", opts);
    exe.linkLibC();
    // glfw
    exe.addIncludePath(b.path("externals/glfw/include"));
    exe.addIncludePath(b.path("externals/glfw/deps"));
    // glfw(windows向け)
    {
        exe.addCSourceFiles(.{
            .root = b.path("externals/glfw/src"),
            .files = &.{
                "context.c",
                "init.c",
                "input.c",
                "monitor.c",
                "vulkan.c",
                "window.c",
                "platform.c",
                "null_init.c",
                "null_joystick.c",
                "null_monitor.c",
                "null_window.c",
                // win32
                "win32_init.c",
                "win32_joystick.c",
                "win32_module.c",
                "win32_monitor.c",
                "win32_time.c",
                "win32_thread.c",
                "win32_window.c",
                "wgl_context.c",
                "egl_context.c",
                "osmesa_context.c",
            },
            .flags = &[_][]const u8{ "-D_GLFW_WIN32=1", "-D_UNICODE=1" },
        });
        // glad
        exe.addIncludePath(b.path("externals/glad/include")); //FIXME:公開されてるがよいか
        exe.addCSourceFiles(.{
            .root = b.path("externals/glad/src"),
            .files = &.{
                "glad.c",
            },
        });
        exe.linkSystemLibrary("user32");
        exe.linkSystemLibrary("gdi32");
        exe.linkSystemLibrary("shell32");
        exe.linkSystemLibrary("OpenGL32");
    }

    // This declares intent for the executable to be installed into the
    // standard location when the user invokes the "install" step (the default
    // step when running `zig build`).
    b.installArtifact(exe);

    // This *creates* a Run step in the build graph, to be executed when another
    // step is evaluated that depends on it. The next line below will establish
    // such a dependency.
    const run_cmd = b.addRunArtifact(exe);

    // By making the run step depend on the install step, it will be run from the
    // installation directory rather than directly from within the cache directory.
    // This is not necessary, however, if the application depends on other installed
    // files, this ensures they will be present and in the expected location.
    run_cmd.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig build run`
    // This will evaluate the `run` step rather than the default, which is "install".
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
