const std = @import("std");
const rl = @import("raylib");
const dearzig = @import("dearzig");
const imgui = dearzig.c;
const rlimgui = dearzig.rl_backend;

pub fn main() !void {
    rl.initWindow(1280, 720, "dearzig example");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    try rlimgui.setup(true);
    defer rlimgui.shutdown();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        rl.clearBackground(.black);

        rlimgui.begin();

        _ = imgui.ImGui_Begin("Hello dearzig", null, 0);
        imgui.ImGui_Text("It works!");
        imgui.ImGui_End();

        rlimgui.end();

        rl.endDrawing();
    }
}
