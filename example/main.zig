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

        var buf: [128:0]u8 = [_:0]u8{0} ** 128;
        rlimgui.begin();

        const t: f32 = @floatCast(rl.getTime());
        const cam_x = @sin(t) * 5.0;
        const cam_z = @cos(t) * 5.0;

        rl.beginMode3D(.{
            .position = .{ .x = cam_x, .y = 2, .z = cam_z },
            .target = .{ .x = 0, .y = 0, .z = 0 },
            .up = .{ .x = 0, .y = 1, .z = 0 },
            .fovy = 45,
            .projection = .perspective,
        });

        rl.drawCubeV(.{ .x = 0, .y = 0, .z = 0 }, .{ .x = 1, .y = 1, .z = 1 }, .red);
        rl.drawCubeWiresV(.{ .x = 0, .y = 0, .z = 0 }, .{ .x = 1, .y = 1, .z = 1 }, .white);

        rl.endMode3D();

        imgui.ImGui_SetNextWindowSize(.{ .x = 400, .y = 200 }, imgui.ImGuiCond_FirstUseEver);
        _ = imgui.ImGui_Begin("dearzig demo", null, 0);

        imgui.ImGui_Text("Dear ImGui + Raylib + Zig");
        imgui.ImGui_Separator();
        _ = imgui.ImGui_InputText("Type here", &buf, 128, 0);
        imgui.ImGui_Text("FPS:");
        imgui.ImGui_SameLine();
        var fps_buf: [32]u8 = undefined;
        const fps_str = std.fmt.bufPrintZ(&fps_buf, "{d}", .{rl.getFPS()}) catch "?";
        imgui.ImGui_Text(fps_str);

        imgui.ImGui_End();

        // show imgui demo window for full feature showcase
        imgui.ImGui_ShowDemoWindow(null);

        rlimgui.end();

        rl.endDrawing();
    }
}
