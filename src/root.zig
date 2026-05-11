pub const c = @cImport({
    @cInclude("dcimgui.h");
    @cInclude("dcimgui_impl_opengl3.h");
});

pub const rl_backend = @import("raylib.zig");
