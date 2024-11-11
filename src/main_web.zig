const std = @import("std");
const game = @import("game.zig");

export fn onInit() void {
    game.init();
}

var previous: c_int = 0;
var x: f32 = 0;

export fn onAnimationFrame(timestamp: c_int) void {
    const delta = if (previous > 0) timestamp - previous else 0;
    x += @as(f32, @floatFromInt(delta)) / 1000.0;
    if (x > 1) x = -2;

    previous = timestamp;

    game.render(500, 400);
}
