const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const upstream = b.dependency("SDL_ttf", .{});

    const mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .strip = true,
    });

    const lib = b.addLibrary(.{
        .name = "SDL2_ttf",
        .version = .{ .major = 2, .minor = 25, .patch = 0 },
        .linkage = .static,
        .root_module = mod,
    });
    mod.addIncludePath(upstream.path("."));
    mod.addCSourceFiles(.{
        .root = upstream.path("."),
        .files = srcs,
    });

    const freetype_dep = b.dependency("freetype", .{
        .target = target,
        .optimize = optimize,
    });
    mod.linkLibrary(freetype_dep.artifact("freetype"));

    const sdl_dep = b.dependency("SDL", .{
        .target = target,
        .optimize = optimize,
    });
    mod.linkLibrary(sdl_dep.artifact("SDL2"));

    lib.installHeadersDirectory(upstream.path("SDL_ttf.h"), "SDL_ttf.h", .{});

    b.installArtifact(lib);
}

const srcs: []const []const u8 = &.{
    "glfont.c",
    "showfont.c",
    "SDL_ttf.c",
};
