import type { CurrencyCode, TournamentFormat } from "@/types/tournament";

export function formatMoney(amountMinor: number, currency: CurrencyCode = "BDT"): string {
  if (!Number.isSafeInteger(amountMinor)) {
    throw new RangeError("Money amount must be a safe integer in minor units.");
  }
  const absolute = Math.abs(amountMinor);
  const whole = Math.floor(absolute / 100);
  const minorFraction = absolute % 100;
  const decimal = minorFraction === 0 ? "" : `.${String(minorFraction).padStart(2, "0")}`;
  const sign = amountMinor < 0 ? "-" : "";
  if (currency === "BDT") {
    return `${sign}৳${new Intl.NumberFormat("en-BD").format(whole)}${decimal}`;
  }
  const parts = new Intl.NumberFormat("en", {
    style: "currency",
    currency,
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).formatToParts(whole);
  let lastInteger = -1;
  for (let index = 0; index < parts.length; index += 1) {
    if (parts[index].type === "integer") lastInteger = index;
  }
  return `${sign}${parts.map((part, index) => `${part.value}${index === lastInteger ? decimal : ""}`).join("")}`;
}

export function formatTournamentDate(date: string): string {
  return new Intl.DateTimeFormat("en-BD", {
    dateStyle: "medium",
    timeStyle: "short",
    timeZone: "Asia/Dhaka",
  }).format(new Date(date));
}

export function formatFormat(format: string): string {
  return format
    .toLowerCase()
    .split("_")
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join(" ");
}

export function roadmapLabel(format: TournamentFormat): string {
  return format === "SWISS"
    ? "Swiss rounds"
    : format === "ROUND_ROBIN"
      ? "Group standings"
      : `${formatFormat(format)} bracket`;
}
