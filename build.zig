const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.addModule("dearzig", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    module.addIncludePath(b.path("common/imgui"));
    module.addIncludePath(b.path("common/imgui/backends"));
    module.addCSourceFile(.{ .file = b.path("common/imgui/imgui.cpp"), .flags = &.{} });
    module.addCSourceFile(.{ .file = b.path("common/imgui/imgui_widgets.cpp"), .flags = &.{} });
    module.addCSourceFile(.{ .file = b.path("common/imgui/imgui_tables.cpp"), .flags = &.{} });
    module.addCSourceFile(.{ .file = b.path("common/imgui/imgui_draw.cpp"), .flags = &.{} });
    module.addCSourceFile(.{ .file = b.path("common/imgui/imgui_demo.cpp"), .flags = &.{} });
    module.addCSourceFile(.{ .file = b.path("common/imgui/dcimgui.cpp"), .flags = &.{} });
    module.addCSourceFile(.{ .file = b.path("common/imgui/dcimgui_internal.cpp"), .flags = &.{} });
    module.addCSourceFile(.{ .file = b.path("common/imgui/imgui_impl_opengl3.cpp"), .flags = &.{} });
    module.addCSourceFile(.{ .file = b.path("common/imgui/dcimgui_impl_opengl3.cpp"), .flags = &.{} });

    // example executable
    const exe = b.addExecutable(.{
        .name = "dearzig-example",
        .root_module = b.createModule(.{
            .root_source_file = b.path("example/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    exe.root_module.addImport("dearzig", module);
    exe.linkLibCpp();
    b.installArtifact(exe);

    const raylib_dep = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib = raylib_dep.module("raylib");
    const raylib_artifact = raylib_dep.artifact("raylib");

    module.addImport("raylib", raylib);
    module.linkLibrary(raylib_artifact);

    // also for the example exe
    exe.root_module.addImport("raylib", raylib);
    exe.linkLibrary(raylib_artifact);
}
