const std = @import("std");
const rl = @import("raylib");
const imgui = @import("root.zig").c;

pub fn setup(dark_theme: bool) !void {
    _ = imgui.ImGui_CreateContext(null);

    const io = imgui.ImGui_GetIO();
    io.*.ConfigFlags |= imgui.ImGuiConfigFlags_NavEnableKeyboard;

    if (dark_theme) {
        imgui.ImGui_StyleColorsDark(null);
    } else {
        imgui.ImGui_StyleColorsLight(null);
    }

    _ = imgui.cImGui_ImplOpenGL3_InitEx("#version 330");
}

pub fn shutdown() void {
    imgui.cImGui_ImplOpenGL3_Shutdown();
    imgui.ImGui_DestroyContext(null);
}

pub fn begin() void {
    const io = imgui.ImGui_GetIO();

    io.*.DisplaySize = .{
        .x = @floatFromInt(rl.getScreenWidth()),
        .y = @floatFromInt(rl.getScreenHeight()),
    };
    io.*.DeltaTime = rl.getFrameTime();

    const mouse = rl.getMousePosition();
    io.*.MousePos = .{ .x = mouse.x, .y = mouse.y };
    io.*.MouseDown[0] = rl.isMouseButtonDown(.left);
    io.*.MouseDown[1] = rl.isMouseButtonDown(.right);
    io.*.MouseDown[2] = rl.isMouseButtonDown(.middle);
    io.*.MouseWheel = rl.getMouseWheelMove();

    imgui.cImGui_ImplOpenGL3_NewFrame();
    imgui.ImGui_NewFrame();
}

pub fn end() void {
    imgui.ImGui_Render();
    imgui.cImGui_ImplOpenGL3_RenderDrawData(imgui.ImGui_GetDrawData());
}
