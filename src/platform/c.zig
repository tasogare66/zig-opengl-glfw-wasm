const c = @cImport({
    @cInclude("glad/gl.h");
});
pub usingnamespace c;

pub const std = @import("std");
pub const allocator = std.heap.c_allocator;
pub const panic = std.debug.panic;

pub fn compileShaderProgram(source: [*:0]const u8, len: c_uint, kind: c_uint) c_uint {
    _ = len;
    const shader_id = c.glCreateShader(kind);
    c.glShaderSource(shader_id, 1, &source, null);
    c.glCompileShader(shader_id);
    return shader_id;
}

pub fn linkShaderProgram(vertex_shader: c_uint, fragment_shader: c_uint) c_uint {
    const program = c.glCreateProgram();
    c.glAttachShader(program, vertex_shader);
    c.glAttachShader(program, fragment_shader);
    c.glLinkProgram(program);
    return program;
}
