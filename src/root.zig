const std = @import("std");

const lut3 = [std.math.pow(u8, 2, 3)]u8{ 0x00, 0x25, 0x49, 0x6E, 0x92, 0xB7, 0xDB, 0xFF };

pub fn c332u8c888u8(c: u8) [3]u8 {
    const r: u8 = (c >> 5) & 0b0000_0111;
    const g: u8 = (c >> 2) & 0b0000_0111;
    const b: u8 = (c >> 0) & 0b0000_0011;

    // The LUT is computed as follows for red and green: const rf: f32 = @as(f32, @floatFromInt(r)) * (255.0 / 7.0); then const rr: u8 = @intFromFloat(std.math.ceil(rf));
    const rr: u8 = lut3[r];
    const gg: u8 = lut3[g];
    const bb: u8 = b * (0xFF / 3);

    return .{ rr, gg, bb };
}

pub fn c888i8c332i8(_r: i8, _g: i8, _b: i8) i8 {
    return @bitCast(c888u8c332u8(@bitCast(_r), @bitCast(_g), @bitCast(_b)));
}

pub fn c888u8c332u8(_r: u8, _g: u8, _b: u8) u8 {
    const r: u8 = (_r & 0b0000_0111) << 5;
    const g: u8 = (_g & 0b0000_0111) << 2;
    const b: u8 = (_b & 0b0000_0011) << 0;
    return r | g | b;
}

pub fn c888i8c332i8Exact(_r: i8, _g: i8, _b: i8) i8 {
    return @bitCast(c888u8c332u8Exact(@bitCast(_r), @bitCast(_g), @bitCast(_b)));
}

pub fn c888u8c332u8Exact(_r: u8, _g: u8, _b: u8) u8 {
    var r: u8 = 0x00;
    var g: u8 = 0x00;
    const b: u8 = @divExact(_b, 0x55);

    for (0..lut3.len) |lut__index| {
        if (lut3[lut__index] == _r) {
            r = @intCast(lut__index);
        }
        if (lut3[lut__index] == _g) {
            g = @intCast(lut__index);
        }
    }

    return ((r & 0b0000_0111) << 5) | ((g & 0b0000_0111) << 2) | ((b & 0b0000_0011) << 0);
}
