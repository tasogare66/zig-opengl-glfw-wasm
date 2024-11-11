const build_config = @import("config");
pub const WEB_BUILD = build_config.web_build;

pub usingnamespace if (WEB_BUILD) @import("platform/web.zig") else @import("platform/c.zig");
