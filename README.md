# zig-opengl-glfw-wasm
Draw triangle with OpenGL+GLFW or webgl2.

zig version 0.13.0

![screenshot](img/ss2024-11-13080753.png)

## Dependencies
glfw

## Run

```sh
zig build run
```

## Build wasm

```sh
zig build -p web -Dtarget-web
python3 -m http.server --directory ./web
```
