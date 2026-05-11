# dearzig

Dear ImGui bindings for Zig + Raylib. Uses the official [dear_bindings](https://github.com/dearimgui/dear_bindings) C bindings — no abandoned wrappers, no C++ in your Zig code.

```zig
const imgui = @import("dearzig");

// in your main loop
imgui.ImGui_NewFrame();
_ = imgui.ImGui_Begin("Hello", null, 0);
imgui.ImGui_Text("It works.");
imgui.ImGui_End();
imgui.ImGui_Render();
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
- Raylib 5.6.x (via [raylib-zig](https://github.com/Not-Nik/raylib-zig))
- Python 3.x (only needed to regenerate bindings)

---

## Setup

### 1. Add dearzig to your build.zig.zon

```zig
.dependencies = .{
    .dearzig = .{
        .url = "https://github.com/yourusername/dearzig/archive/refs/heads/main.tar.gz",
        .hash = "...",
    },
},
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

### 3. Init in your main loop

```zig
const rl = @import("raylib");
const imgui = @import("dearzig");

pub fn main() !void {
    rl.initWindow(1920, 1080, "dearzig example");
    defer rl.closeWindow();

    imgui.rlImGui_Setup(true);
    defer imgui.rlImGui_Shutdown();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        rl.clearBackground(.black);

        imgui.rlImGui_Begin();

        _ = imgui.ImGui_Begin("My Panel", null, 0);
        imgui.ImGui_Text("Hello from dearzig!");
        imgui.ImGui_End();

        imgui.rlImGui_End();

        rl.endDrawing();
    }
}
```

---

## Regenerating bindings

If you need to update to a newer ImGui version:

```bash
git clone https://github.com/ocornut/imgui.git
git clone https://github.com/dearimgui/dear_bindings.git

cd dear_bindings
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
./BuildAllBindings.sh
deactivate

# copy generated/ into dearzig/common/imgui/
```

---

## Project structure

```
dearzig/
  build.zig
  build.zig.zon
  src/
    root.zig        ← main API, re-exports dear_bindings
    raylib.zig      ← rlImGui Raylib backend
  common/
    imgui/          ← ImGui sources + dear_bindings generated files
  example/
    main.zig        ← working Raylib + ImGui demo
  README.md
```

---

## License

ImGui — MIT  
dear_bindings — MIT  
dearzig — MIT
