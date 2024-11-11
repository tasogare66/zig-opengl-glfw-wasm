const std = @import("std");
const game = @import("game.zig");

// Shaders
extern fn compileShaderProgram(source: [*:0]const u8, len: c_uint, type: c_uint) c_uint;
//extern fn compileShaderProgram(source: *const u8, len: c_uint, type: c_uint) c_uint;
extern fn linkShaderProgram(vertexShaderId: c_uint, fragmentShaderId: c_uint) c_uint;

// GL
extern fn glClearColor(_: f32, _: f32, _: f32, _: f32) void;
extern fn glEnable(_: c_uint) void;
extern fn glDepthFunc(_: c_uint) void;
extern fn glClear(_: c_uint) void;
//extern fn glGetAttribLocation(_: c_uint, _: *const u8, _: c_uint) c_int;
//extern fn glGetUniformLocation(_: c_uint, _: *const u8, _: c_uint) c_int;
extern fn glGetAttribLocation(_: c_uint, name: [*:0]const u8) c_int;
extern fn glGetUniformLocation(_: c_uint, name: [*:0]const u8) c_int;
extern fn glUniform4fv(_: c_int, _: f32, _: f32, _: f32, _: f32) void;
extern fn glCreateBuffer() c_uint;
extern fn glBindBuffer(_: c_uint, _: c_uint) void;
extern fn glBufferData(_: c_uint, _: c_uint, _: ?*const anyopaque, _: c_uint) void;
extern fn glUseProgram(_: c_uint) void;
extern fn glEnableVertexAttribArray(_: c_uint) void;
extern fn glVertexAttribPointer(_: c_uint, _: c_uint, _: c_uint, _: c_uint, _: c_uint, _: ?*const anyopaque) void;
extern fn glDrawArrays(_: c_uint, _: c_uint, _: c_uint) void;

// Identifier constants pulled from WebGLRenderingContext
const GL_VERTEX_SHADER: c_uint = 35633;
const GL_FRAGMENT_SHADER: c_uint = 35632;
const GL_ARRAY_BUFFER: c_uint = 34962;
const GL_TRIANGLES: c_uint = 4;
const GL_STATIC_DRAW: c_uint = 35044;
const GL_f32: c_uint = 5126;
const GL_DEPTH_TEST: c_uint = 2929;
const GL_LEQUAL: c_uint = 515;
const GL_COLOR_BUFFER_BIT: c_uint = 16384;
const GL_DEPTH_BUFFER_BIT: c_uint = 256;

const vertexShader =
    \\attribute vec4 a_position;
    \\uniform vec4 u_offset;
    \\void main() {
    \\  gl_Position = a_position + u_offset;
    \\}
;

const fragmentShader =
    \\precision mediump float;
    \\void main() {
    \\ gl_FragColor = vec4(0.3, 0.6, 1.0, 1.0);
    \\}
;

const positions = [_]f32{ 0, 0, 0, 0.5, 0.7, 0 };

var program_id: c_uint = undefined;
var positionAttributeLocation: c_int = undefined;
var offsetUniformLocation: c_int = undefined;
var positionBuffer: c_uint = undefined;

export fn onInit() void {
    // glClearColor(0.1, 0.1, 0.1, 1.0);
    // glEnable(GL_DEPTH_TEST);
    // glDepthFunc(GL_LEQUAL);
    // glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // const vertex_shader_id = compileShaderProgram(vertexShader, vertexShader.len, GL_VERTEX_SHADER);
    // const fsId = compileShaderProgram(fragmentShader, fragmentShader.len, GL_FRAGMENT_SHADER);

    // program_id = linkShaderProgram(vertex_shader_id, fsId);

    // positionAttributeLocation = glGetAttribLocation(program_id, "a_position");
    // offsetUniformLocation = glGetUniformLocation(program_id, "u_offset");

    // positionBuffer = glCreateBuffer();
    // glBindBuffer(GL_ARRAY_BUFFER, positionBuffer);
    // glBufferData(GL_ARRAY_BUFFER, 6, &positions, GL_STATIC_DRAW);

    game.init();
}

var previous: c_int = 0;
var x: f32 = 0;

export fn onAnimationFrame(timestamp: c_int) void {
    const delta = if (previous > 0) timestamp - previous else 0;
    x += @as(f32, @floatFromInt(delta)) / 1000.0;
    if (x > 1) x = -2;

    // glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // glUseProgram(program_id);
    // glEnableVertexAttribArray(@as(c_uint, @intCast(positionAttributeLocation)));
    // glBindBuffer(GL_ARRAY_BUFFER, positionBuffer);
    // glVertexAttribPointer(@as(c_uint, @intCast(positionAttributeLocation)), 2, GL_f32, 0, 0, null);
    // glUniform4fv(offsetUniformLocation, x, 0.0, 0.0, 0.0);
    // glDrawArrays(GL_TRIANGLES, 0, 3);
    previous = timestamp;

    game.render(500, 400);
}
