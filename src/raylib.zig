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

    // mouse position and buttons
    const mouse = rl.getMousePosition();
    io.*.MousePos = .{ .x = mouse.x, .y = mouse.y };
    io.*.MouseDown[0] = rl.isMouseButtonDown(.left);
    io.*.MouseDown[1] = rl.isMouseButtonDown(.right);
    io.*.MouseDown[2] = rl.isMouseButtonDown(.middle);

    // scroll
    io.*.MouseWheel = rl.getMouseWheelMove();
    io.*.MouseWheelH = rl.getMouseWheelMoveV().x;

    // keyboard modifiers
    io.*.KeyCtrl  = rl.isKeyDown(.left_control) or rl.isKeyDown(.right_control);
    io.*.KeyShift = rl.isKeyDown(.left_shift)   or rl.isKeyDown(.right_shift);
    io.*.KeyAlt   = rl.isKeyDown(.left_alt)     or rl.isKeyDown(.right_alt);
    io.*.KeySuper = rl.isKeyDown(.left_super)   or rl.isKeyDown(.right_super);

    // text input
    var char = rl.getCharPressed();
    while (char != 0) {
        imgui.ImGuiIO_AddInputCharacter(io, @intCast(char));
        char = rl.getCharPressed();
    }

    // keyboard keys
    const key_map = .{
        .{ rl.KeyboardKey.tab,            imgui.ImGuiKey_Tab },
        .{ rl.KeyboardKey.left,           imgui.ImGuiKey_LeftArrow },
        .{ rl.KeyboardKey.right,          imgui.ImGuiKey_RightArrow },
        .{ rl.KeyboardKey.up,             imgui.ImGuiKey_UpArrow },
        .{ rl.KeyboardKey.down,           imgui.ImGuiKey_DownArrow },
        .{ rl.KeyboardKey.enter,          imgui.ImGuiKey_Enter },
        .{ rl.KeyboardKey.escape,         imgui.ImGuiKey_Escape },
        .{ rl.KeyboardKey.backspace,      imgui.ImGuiKey_Backspace },
        .{ rl.KeyboardKey.delete,         imgui.ImGuiKey_Delete },
        .{ rl.KeyboardKey.home,           imgui.ImGuiKey_Home },
        .{ rl.KeyboardKey.end,            imgui.ImGuiKey_End },
        .{ rl.KeyboardKey.page_up,        imgui.ImGuiKey_PageUp },
        .{ rl.KeyboardKey.page_down,      imgui.ImGuiKey_PageDown },
        .{ rl.KeyboardKey.left_control,   imgui.ImGuiKey_LeftCtrl },
        .{ rl.KeyboardKey.right_control,  imgui.ImGuiKey_RightCtrl },
        .{ rl.KeyboardKey.left_shift,     imgui.ImGuiKey_LeftShift },
        .{ rl.KeyboardKey.right_shift,    imgui.ImGuiKey_RightShift },
        .{ rl.KeyboardKey.left_alt,       imgui.ImGuiKey_LeftAlt },
        .{ rl.KeyboardKey.right_alt,      imgui.ImGuiKey_RightAlt },
        .{ rl.KeyboardKey.a,              imgui.ImGuiKey_A },
        .{ rl.KeyboardKey.c,              imgui.ImGuiKey_C },
        .{ rl.KeyboardKey.v,              imgui.ImGuiKey_V },
        .{ rl.KeyboardKey.x,              imgui.ImGuiKey_X },
        .{ rl.KeyboardKey.y,              imgui.ImGuiKey_Y },
        .{ rl.KeyboardKey.z,              imgui.ImGuiKey_Z },
    };

    inline for (key_map) |pair| {
        imgui.ImGuiIO_AddKeyEvent(io, pair[1], rl.isKeyDown(pair[0]));
    }

    imgui.cImGui_ImplOpenGL3_NewFrame();
    imgui.ImGui_NewFrame();
}

pub fn end() void {
    imgui.ImGui_Render();
    imgui.cImGui_ImplOpenGL3_RenderDrawData(imgui.ImGui_GetDrawData());
}
