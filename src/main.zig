const std = @import("std");
const game = @import("game.zig");
const c = @cImport({
    @cInclude("glad/gl.h");
    @cInclude("GLFW/glfw3.h");
});

pub fn main() !void {
    // ↓ glfw
    std.debug.assert(c.glfwInit() != 0);
    defer c.glfwTerminate();

    // Create a windowed mode window and its OpenGL context
    const window = c.glfwCreateWindow(640, 480, "zig-opengl-glfw-wasm", null, null);
    std.debug.assert(window != null);
    defer c.glfwDestroyWindow(window);

    // Make the window's context current
    c.glfwMakeContextCurrent(window);
    // glad による OpenGL 初期化
    _ = c.gladLoadGL(c.glfwGetProcAddress);
    // game共通部初期化
    game.init();
    c.glfwSwapInterval(1);

    // Loop until the user closes the window
    while (c.glfwWindowShouldClose(window) == 0) {
        // Poll for and process events
        c.glfwPollEvents();

        var width: c_int = undefined;
        var height: c_int = undefined;
        c.glfwGetFramebufferSize(window, &width, &height);

        // game共通部描画
        game.render(width, height);

        // Swap front and back buffers
        c.glfwSwapBuffers(window);
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
