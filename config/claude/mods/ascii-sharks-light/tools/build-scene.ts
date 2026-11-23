// capture.json (from capture.ts) → hooks/scene.ts, the backdrop SVG as a string.
// Only steps() animations: continuous transforms froze the backdrop in the app.
import { readFileSync, writeFileSync } from "node:fs";

type Cell = { c: number; r: number; bg?: string; fg?: string; g?: string };
type Capture = {
  view: [number, number];
  cell: [number, number];
  loopSeconds: number;
  fishSeconds: number;
  sharks: { kind: string; cells: number; rows: number; frames: Cell[][] }[];
  fish: { frames: Cell[][] };
};

const [input, outTs, outSvg] = process.argv.slice(2);
const cap: Capture = JSON.parse(readFileSync(input, "utf8"));
const [W, H] = cap.view;
const [cw, ch] = cap.cell;

const PAGE = "#e9edf0";
const INK = [45, 60, 78];
const LANES = [0.45];
const MAX = 131_072;

function rgb(s: string): [number, number, number, number] {
  if (s.startsWith("#")) {
    const n = parseInt(s.slice(1), 16);
    return [n >> 16, (n >> 8) & 255, n & 255, 1];
  }
  const [r, g, b, a = 1] = s.replace(/[^\d.,]/g, "").split(",").map(Number);
  return [r, g, b, a];
}

const hex = (r: number, g: number, b: number) =>
  "#" + [r, g, b].map((v) => Math.round(Math.min(255, Math.max(0, v))).toString(16).padStart(2, "0")).join("");

function calm([r, g, b]: number[], lift = 0) {
  const y = 0.3 * r + 0.59 * g + 0.11 * b;
  const mix = (v: number) => y + (v - y) * 0.45;
  return [mix(r), mix(g), mix(b)].map((v) => lift + v * (1 - lift / 255));
}

// Few colours keep each frame short: every extra colour in a row costs a tspan.
const lum = ([r, g, b]: number[]) => 0.3 * r + 0.59 * g + 0.11 * b;
const SKIN_STEPS = 6;
const skin = (s: string) => {
  const y = lum(calm(rgb(s), 70));
  const t = Math.round(((y - 70) / 185) * (SKIN_STEPS - 1)) / (SKIN_STEPS - 1);
  const v = 92 + t * 130;
  return hex(v - 4, v, v + 6);
};
const ACCENT_HUES = ["#a8835a", "#a35d58", "#7f6c99", "#5f8f92", "#6a8f68", "#5d6fa3", "#a39a62"];
const ink = (s: string) => {
  const c = rgb(s);
  const y = lum(c);
  if (Math.max(c[0], c[1], c[2]) - Math.min(c[0], c[1], c[2]) > 60) {
    const i = ["#e0892c", "#e03a32", "#b44ae0", "#33c8cc", "#3cb54a", "#3150e8", "#d9c14a"].indexOf(s);
    return ACCENT_HUES[i < 0 ? 0 : i]!;
  }
  if (y > 200) return "#f6f8fa";
  if (y < 40) return "#151a21";
  return y < 95 ? "#5b6670" : "#8a949d";
};
const DEFAULT_INK = "#151a21";
// Skin colours fill through a one-cell pattern that leaves the repo's 1px gap
// transparent, so the page grid shows between blocks and nowhere else changes.
const skins = new Set<string>();

// Every colour becomes a short class, defined once in the stylesheet.
const classes = new Map<string, string>();
const cls = (color: string) => {
  let k = classes.get(color);
  if (!k) {
    let n = classes.size;
    k = "";
    do { k = String.fromCharCode(97 + (n % 26)) + k; n = Math.floor(n / 26) - 1; } while (n >= 0);
    k = "k" + k;
    classes.set(color, k);
  }
  return k;
};

const esc = (g: string) => (g === "<" ? "&lt;" : g === "&" ? "&amp;" : g);
const n2 = (v: number) => +v.toFixed(2);
const rowY = (r: number) => n2(((r + 0.5) * ch + 1) / cw);

function group<T>(list: T[], key: (t: T) => string) {
  const m = new Map<string, T[]>();
  for (const t of list) (m.get(key(t)) ?? m.set(key(t), []).get(key(t))!).push(t);
  return m;
}

function frameSvg(cells: Cell[], c0: number, r0: number, dx: number) {
  const rects = [...group(cells.filter((c) => c.bg), (c) => skin(c.bg!))]
    .map(([color, list]) => {
      list.sort((a, b) => a.r - b.r || a.c - b.c);
      let d = "";
      for (let i = 0; i < list.length; ) {
        let j = i + 1;
        while (j < list.length && list[j].r === list[i].r && list[j].c === list[j - 1].c + 1) j++;
        d += `M${list[i].c - c0 + dx} ${list[i].r - r0}h${j - i}v1h-${j - i}z`;
        i = j;
      }
      skins.add(color);
      return `<path class="${cls(color)}" d="${d}"/>`;
    })
    .join("");
  const texts = [...group(cells.filter((c) => c.g), (c) => String(c.r))]
    .map(([row, list]) => {
      const byInk = group(list, (c) => ink(c.fg!));
      const xs = (run: Cell[]) => run.sort((a, b) => a.c - b.c).map((c) => c.c - c0 + dx).join(" ");
      const glyphs = (run: Cell[]) => run.map((c) => esc(c.g!)).join("");
      const plain = byInk.get(DEFAULT_INK) ?? [];
      byInk.delete(DEFAULT_INK);
      const spans = [...byInk].map(([color, run]) => `<tspan class="${cls(color)}" x="${xs(run)}">${glyphs(run)}</tspan>`).join("");
      return `<text y="${rowY(+row - r0)}"${plain.length ? ` x="${xs(plain)}"` : ""}>${glyphs(plain)}${spans}</text>`;
    })
    .join("");
  return { rects, texts };
}

function sharkLane(s: Capture["sharks"][number], i: number) {
  const all = s.frames.flat();
  const c0 = Math.min(...all.map((c) => c.c));
  const r0 = Math.min(...all.map((c) => c.r));
  const cols = Math.max(...all.map((c) => c.c)) - c0 + 1;
  const rows = Math.max(...all.map((c) => c.r)) - r0 + 1;
  const F = s.frames.length;
  const parts = s.frames.map((f) => frameSvg(f, c0, r0, 0));
  // Each frame sits in its own shifted group so its coordinates stay two digits.
  const at = (k: number, body: string) => (k ? `<g transform="translate(${k * cols})">${body}</g>` : body);
  const dx = s.cells * cw;
  const dy = s.rows * ch;
  const loops = Math.ceil((W + cols * cw) / Math.abs(dx)) + 1;
  // Start off one side so the lane's middle passes LANES[i] of the height.
  const fromX = dx > 0 ? -cols * cw : W - (cols - Math.abs(s.cells)) * cw;
  const fromY = Math.round((H * LANES[i]) / ch - rows / 2 - (loops * s.rows) / 2) * ch;
  const [toX, toY] = [fromX + loops * dx, fromY + loops * dy];
  const css =
    `.l${i}{animation:l${i} ${n2(loops * cap.loopSeconds)}s steps(${loops}) infinite}` +
    `@keyframes l${i}{from{transform:translate(${fromX}px,${fromY}px)}to{transform:translate(${toX}px,${toY}px)}}` +
    `.s${i}{animation:s${i} ${cap.loopSeconds}s steps(${F}) infinite}` +
    `@keyframes s${i}{to{transform:translateX(${-F * cols}px)}}`;
  const svg =
    `<g class="l${i}"><svg width="${cols * cw}" height="${rows * ch}" viewBox="0 0 ${cols} ${rows}" preserveAspectRatio="none" overflow="hidden">` +
    `<g class="s${i}">${parts.map((p, k) => at(k, p.rects)).join("")}</g>` +
    `</svg><svg width="${cols * cw}" height="${rows * ch}" viewBox="-0.5 0 ${cols} ${n2((rows * ch) / cw)}" overflow="hidden">` +
    `<g class="s${i}">${parts.map((p, k) => at(k, p.texts)).join("")}</g></svg></g>`;
  return { css, svg, frameChars: Math.round(parts.reduce((n, p) => n + p.rects.length + p.texts.length, 0) / F) };
}


const lanes = cap.sharks.map(sharkLane);
const palette = [...classes].map(([color, k]) => `.${k}{fill:${skins.has(color) ? `url(#${k}p)` : color}}`).join("");
const skinPatterns = [...skins]
  .map((color) => `<pattern id="${cls(color)}p" width="1" height="1" patternUnits="userSpaceOnUse"><rect x="${n2(1 / cw)}" y="${n2(1 / ch)}" width="${n2(1 - 1 / cw)}" height="${n2(1 - 1 / ch)}" fill="${color}"/></pattern>`)
  .join("");
const svg =
  `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${W} ${H}" preserveAspectRatio="xMidYMid slice">` +
  `<style>text{fill:${DEFAULT_INK};font:600 ${n2((ch * 0.74) / cw)}px ui-monospace,"SF Mono",Menlo,monospace;text-anchor:middle;dominant-baseline:central}` +
  palette +
  lanes.map((l) => l.css).join("") +
  `@media (prefers-reduced-motion:reduce){*{animation:none!important}}</style>` +
  `<defs><pattern id="grid" width="${cw}" height="${ch}" patternUnits="userSpaceOnUse"><path d="M0 0H${cw}M0 0V${ch}" stroke="rgba(${INK.join(",")},0.07)" fill="none"/></pattern>` +
  `${skinPatterns}</defs>` +
  `<rect width="${W}" height="${H}" fill="${PAGE}"/><rect width="${W}" height="${H}" fill="url(#grid)"/>` +
  lanes.map((l) => l.svg).join("") +
  `</svg>`;

console.log(`lanes ${lanes.map((l) => l.svg.length)}, per frame ${lanes.map((l) => l.frameChars)}, classes ${classes.size}`);
console.log(`scene: ${svg.length} characters (limit ${MAX})`);
if (svg.length > MAX) throw new Error(`scene is ${svg.length} characters, over the ${MAX} limit`);
writeFileSync(outTs, `// Generated by tools/build-scene.ts from ascii-sharks' own renderer. Do not edit by hand.\nexport const SCENE = ${JSON.stringify(svg)}\n`);
if (outSvg) writeFileSync(outSvg, svg);
