import { describe, expect, it } from "vitest";
import { formatMoney } from "./format";

describe("money formatting", () => {
  it("formats BDT minor units without floating-point conversion", () => {
    expect(formatMoney(1_005)).toBe("৳10.05");
    expect(formatMoney(2_000)).toBe("৳20");
    expect(formatMoney(-1_005)).toBe("-৳10.05");
  });

  it("rejects unsafe or fractional minor-unit values", () => {
    expect(() => formatMoney(1.5)).toThrow(RangeError);
    expect(() => formatMoney(Number.MAX_SAFE_INTEGER + 1)).toThrow(RangeError);
  });
});
