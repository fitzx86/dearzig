# dearzig

Dear ImGui bindings for Zig + Raylib. Uses the official [dear_bindings](https://github.com/dearimgui/dear_bindings) C bindings — no abandoned wrappers, no C++ in your Zig code.

```zig
const dearzig = @import("dearzig");
const imgui = dearzig.c;
const rlimgui = dearzig.rl_backend;

// init
rlimgui.setup(true); // true = dark theme
defer rlimgui.shutdown();

// in your main loop
rlimgui.begin();
_ = imgui.ImGui_Begin("Hello", null, 0);
imgui.ImGui_Text("It works.");
imgui.ImGui_End();
rlimgui.end();
```

---

## Why dearzig?

- `zig-imgui` — abandoned 4 years ago
- `cimgui` — unofficial C bindings, lags behind ImGui releases
- `dear_bindings` — official C bindings maintained by the ImGui team
- `dearzig` — thin Zig wrapper around dear_bindings with a Raylib backend

---

## Requirements

- Zig 0.15.x
- Raylib 5.6.x (via [raylib-zig](https://github.com/raylib-zig/raylib-zig))

---

## Setup

### 1. Add dearzig to your build.zig.zon

```zig
.dependencies = .{
    .dearzig = .{
        .url = "https://github.com/fitzx86/dearzig/archive/refs/heads/main.tar.gz",
        .hash = "...", // run zig fetch --save to get hash
    },
},
```

Or use `zig fetch`:
```bash
zig fetch --save https://github.com/fitzx86/dearzig/archive/refs/heads/main.tar.gz
```

### 2. Wire it up in build.zig

```zig
const dearzig = b.dependency("dearzig", .{
    .target = target,
    .optimize = optimize,
});

exe.root_module.addImport("dearzig", dearzig.module("dearzig"));
exe.linkLibCpp();
```

### 3. Use it

```zig
const std = @import("std");
const rl = @import("raylib");
const dearzig = @import("dearzig");
const imgui = dearzig.c;
const rlimgui = dearzig.rl_backend;

pub fn main() !void {
    rl.initWindow(1280, 720, "dearzig example");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    rlimgui.setup(true);
    defer rlimgui.shutdown();

    var buf: [128:0]u8 = [_:0]u8{0} ** 128;

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        rl.clearBackground(.black);

        rlimgui.begin();

        imgui.ImGui_SetNextWindowSize(.{ .x = 400, .y = 200 }, imgui.ImGuiCond_FirstUseEver);
        _ = imgui.ImGui_Begin("Hello dearzig", null, 0);
        imgui.ImGui_Text("Dear ImGui + Raylib + Zig");
        imgui.ImGui_Separator();
        _ = imgui.ImGui_InputText("Type here", &buf, 128, 0);
        imgui.ImGui_End();

        rlimgui.end();

        rl.endDrawing();
    }
}
```

---

## API

dearzig exposes two namespaces:

```zig
const dearzig = @import("dearzig");
const imgui   = dearzig.c;          // all ImGui functions (dcimgui.h)
const rlimgui = dearzig.rl_backend; // Raylib backend
```

### Raylib backend

| Function | Description |
|---|---|
| `rlimgui.setup(dark_theme: bool)` | Init ImGui context + OpenGL3 backend |
| `rlimgui.shutdown()` | Cleanup |
| `rlimgui.begin()` | Start frame, forward Raylib input to ImGui |
| `rlimgui.end()` | Render ImGui draw data |

### ImGui functions

All ImGui functions are available via `dearzig.c`. Note that backend functions use the `cImGui_` prefix from dear_bindings:

```zig
imgui.ImGui_Begin(...)        // standard ImGui functions
imgui.cImGui_ImplOpenGL3_...  // backend functions use cImGui_ prefix
```

---

## Regenerating bindings

To update to a newer ImGui version:

```bash
git clone https://github.com/ocornut/imgui.git
git clone https://github.com/dearimgui/dear_bindings.git

cd dear_bindings
pip install -r requirements.txt  # add ply to your nix env on NixOS
bash BuildAllBindings.sh         # use bash explicitly on NixOS

# copy generated files into common/imgui/
cp generated/dcimgui.cpp common/imgui/
cp generated/dcimgui.h common/imgui/
cp generated/dcimgui_internal.cpp common/imgui/
cp generated/dcimgui_internal.h common/imgui/
cp generated/backends/dcimgui_impl_opengl3.cpp common/imgui/
cp generated/backends/dcimgui_impl_opengl3.h common/imgui/
```

**NixOS note:** Use `bash BuildAllBindings.sh` instead of `./BuildAllBindings.sh` since `/bin/bash` doesn't exist on NixOS. Add `python3Packages.ply` to your dev shell instead of using venv.

---

## Project structure

```
dearzig/
  build.zig
  build.zig.zon
  src/
    root.zig        ← main API, exposes c and rl_backend
    raylib.zig      ← Raylib input forwarding + OpenGL3 rendering
  common/
    imgui/          ← ImGui sources + dear_bindings generated files
  example/
    main.zig        ← spinning cube + ImGui demo window
  README.md
  CLAUDE.md
```

---

## License

ImGui — MIT  
dear_bindings — MIT  
dearzig — MIT
