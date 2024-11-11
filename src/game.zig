const std = @import("std");
const gl = @import("platform.zig");

const Vertex = std.meta.Tuple(&.{ f32, f32, f32, f32, f32 });
const vertices = [3]Vertex{
    .{ -0.6, -0.4, 1.0, 0.0, 0.0 },
    .{ 0.6, -0.4, 0.0, 1.0, 0.0 },
    .{ 0.0, 0.6, 0.0, 0.0, 1.0 },
};

const vertex_shader_text =
    \\#version 300 es
    \\uniform mat4 MVP;
    \\in vec3 vCol;
    \\in vec2 vPos;
    \\out vec3 color;
    \\void main() {
    \\  gl_Position = MVP * vec4(vPos, 0.0, 1.0);
    \\  color = vCol;
    \\}
;

const fragment_shader_text =
    \\#version 300 es
    \\precision mediump float;
    \\in vec3 color;
    \\out vec4 fragment;
    \\void main() {
    \\  fragment = vec4(color, 1.0);
    \\}
;

var program: u32 = undefined;
var mvp_location: c_int = undefined;

pub fn init() void {
    gl.glClearColor(0.0, 0.0, 0.0, 1.0);

    var vertex_buffer: gl.GLuint = undefined;
    gl.glGenBuffers(1, &vertex_buffer);
    gl.glBindBuffer(gl.GL_ARRAY_BUFFER, vertex_buffer);
    gl.glBufferData(gl.GL_ARRAY_BUFFER, @sizeOf(@TypeOf(vertices)), &vertices, gl.GL_STATIC_DRAW);

    const vertex_shader = gl.compileShaderProgram(vertex_shader_text, vertex_shader_text.len, gl.GL_VERTEX_SHADER);
    const fragment_shader = gl.compileShaderProgram(fragment_shader_text, fragment_shader_text.len, gl.GL_FRAGMENT_SHADER);
    program = gl.linkShaderProgram(vertex_shader, fragment_shader);

    mvp_location = gl.glGetUniformLocation(program, "MVP");
    const vpos_location = gl.glGetAttribLocation(program, "vPos");
    const vcol_location = gl.glGetAttribLocation(program, "vCol");

    gl.glEnableVertexAttribArray(@as(c_uint, @intCast(vpos_location)));
    gl.glVertexAttribPointer(@as(c_uint, @intCast(vpos_location)), 2, gl.GL_FLOAT, gl.GL_FALSE, @sizeOf(Vertex), null);
    gl.glEnableVertexAttribArray(@as(c_uint, @intCast(vcol_location)));
    gl.glVertexAttribPointer(@as(c_uint, @intCast(vcol_location)), 3, gl.GL_FLOAT, gl.GL_FALSE, @sizeOf(Vertex), @ptrFromInt(@sizeOf(f32) * 2));
}

pub fn render(width: c_int, height: c_int) void {
    gl.glViewport(0, 0, width, height);
    gl.glClear(gl.GL_COLOR_BUFFER_BIT | gl.GL_DEPTH_BUFFER_BIT);

    var mvp = [_]f32{
        1, 0, 0, 0, //
        0, 1, 0, 0, //
        0, 0, 1, 0, //
        0, 0, 0, 1, //
    };

    gl.glUseProgram(program);
    gl.glUniformMatrix4fv(mvp_location, 1, gl.GL_FALSE, &mvp);
    gl.glDrawArrays(gl.GL_TRIANGLES, 0, 3);
}
