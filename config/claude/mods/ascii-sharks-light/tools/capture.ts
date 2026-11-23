// Runs ascii-sharks' own AsciiRenderer and World against a recording canvas,
// so the scene's cells come from the repo's shapes, not a redrawing of them.
//
// Each shark swims a straight, slightly slanted line. Over one loop it moves a
// whole number of cells and rows, and every frame of the loop is rasterized
// afresh (as the repo does each tick), so frame F equals frame 0 moved one loop
// along: the scene shows the frames in a loop and steps the window per loop.
// A curved path would need a loop as long as its bend, which the size limit can't hold.
// Rebuild: clone github.com/stackedlol/ascii-sharks to /tmp/ascii-sharks first.
import { writeFileSync } from "node:fs";
import { AsciiRenderer } from "/tmp/ascii-sharks/src/renderer";
import { SHARK_NODES, World, type Shark, type SharkKind } from "/tmp/ascii-sharks/src/world";

type Cell = { c: number; r: number; bg?: string; fg?: string; g?: string };

const VIEW_W = 1440;
const VIEW_H = 900;
const LOOP_SECONDS = Number(process.env.LOOP_SECONDS ?? 1.5); // one tail beat, so the body wave is seamless
const FRAMES = Number(process.env.FRAMES ?? 30); // 20 a second, one shark and no fish: 16 ran in the app; with fish, 16 and 20 froze it
const CELL = Number(process.env.CELL ?? 8); // finer than the repo's 12 at this width: smaller steps per frame (8 is near the size limit)
const FISH_FRAMES = Number(process.env.FISH_FRAMES ?? 12);
const FISH_SECONDS = 2.5;

function recordingCanvas() {
  const ops: { kind: "rect" | "text"; x: number; y: number; style: string; g?: string }[] = [];
  let style = "";
  const ctx = new Proxy(
    {
      set fillStyle(v: string) { style = v; },
      get fillStyle() { return style; },
      fillRect(x: number, y: number) { ops.push({ kind: "rect", x, y, style }); },
      fillText(g: string, x: number, y: number) { ops.push({ kind: "text", x, y, style, g }); },
    } as Record<string, unknown>,
    { get: (t, k) => (k in t ? t[k as string] : () => {}), set: (t, k, v) => ((t[k as string] = v), true) },
  );
  const canvas = { width: 0, height: 0, getContext: () => ctx };
  return { canvas, ops };
}

(globalThis as any).document = { createElement: () => recordingCanvas().canvas };

function cellsOf(ops: ReturnType<typeof recordingCanvas>["ops"], cw: number, ch: number): Cell[] {
  const byKey = new Map<string, Cell>();
  for (const op of ops) {
    const c = Math.floor(op.x / cw);
    const r = Math.floor(op.y / ch);
    const key = `${c},${r}`;
    const cell = byKey.get(key) ?? { c, r };
    if (op.kind === "rect") cell.bg = op.style;
    else { cell.fg = op.style; cell.g = op.g; }
    byKey.set(key, cell);
  }
  return [...byKey.values()];
}

function newRenderer() {
  const rec = recordingCanvas();
  const r = new AsciiRenderer(rec.canvas as unknown as HTMLCanvasElement) as any;
  // The repo picks the cell from the width (8 px at least); a finer cell needs a bigger
  // view first so its per-cell arrays are long enough, then the cell set by hand.
  r.resize(VIEW_W * 2, VIEW_H * 2, 1);
  r.cw = CELL;
  r.ch = Math.round(CELL * 1.45);
  r.cols = Math.ceil(VIEW_W / r.cw);
  r.rows = Math.ceil(VIEW_H / r.ch);
  r.width = VIEW_W;
  r.height = VIEW_H;
  return { r, ops: rec.ops };
}

function lineFrames(kind: SharkKind, size: number, cells: number, rows: number) {
  const { r, ops } = newRenderer();
  const { cw, ch } = r;
  const length = Math.min(Math.max(Math.min(VIEW_W, VIEW_H) * 0.44, 170), 430) * size;
  const seg = length / (SHARK_NODES - 1);
  const step = { x: cells * cw, y: rows * ch };
  const heading = Math.atan2(step.y, step.x);
  const speed = Math.hypot(step.x, step.y) / LOOP_SECONDS;
  const hx0 = VIEW_W / 2 + (Math.cos(heading) * length) / 2;
  const hy0 = Math.round(VIEW_H / 2 / ch) * ch + ch / 2;
  const shark = { id: 1, kind, length, speed, heading, turn: 0, depth: size } as unknown as Shark & { nodes: Float32Array };
  const frames: Cell[][] = [];
  for (let k = 0; k <= FRAMES; k++) {
    const t = (k / FRAMES) * LOOP_SECONDS;
    const hx = hx0 + (step.x * k) / FRAMES;
    const hy = hy0 + (step.y * k) / FRAMES;
    const nodes = new Float32Array(SHARK_NODES * 2);
    for (let n = 0; n < SHARK_NODES; n++) {
      nodes[n * 2] = hx - Math.cos(heading) * seg * n;
      nodes[n * 2 + 1] = hy - Math.sin(heading) * seg * n;
    }
    shark.nodes = nodes;
    shark.phase = (k / FRAMES) * Math.PI * 2;
    ops.length = 0;
    r.rasterizeSharks([shark], t);
    r.drawSharks(t);
    frames.push(cellsOf(ops, cw, ch));
  }
  // Frame F must be frame 0 moved one loop along, or the scene jumps at the seam.
  const shape = (list: Cell[], dc: number, dr: number) =>
    list.map((c) => `${c.c + dc},${c.r + dr},${c.bg ? 1 : 0}${c.g ? 1 : 0}`).sort().join("|");
  const next = frames.pop()!;
  if (shape(next, 0, 0) !== shape(frames[0]!, cells, rows)) throw new Error(`${kind}: loop seam does not line up`);
  return { kind, cells, rows, frames };
}

function fishFrames() {
  const { r, ops } = newRenderer();
  const world = new World([], 34);
  world.resize(VIEW_W, VIEW_H, r.cw, r.ch);
  for (let i = 0; i < 600; i++) world.step(1 / 60);
  const frames: Cell[][] = [];
  const perFrame = Math.round((FISH_SECONDS / FISH_FRAMES) * 60);
  for (let k = 0; k < FISH_FRAMES; k++) {
    for (let i = 0; i < perFrame; i++) world.step(1 / 60);
    ops.length = 0;
    r.markFish(world);
    r.drawFish();
    frames.push(cellsOf(ops, r.cw, r.ch));
  }
  return { frames };
}

const { r } = newRenderer();
const sizes = (process.env.SIZES ?? "1").split(",").map(Number);
const out = {
  view: [VIEW_W, VIEW_H],
  cell: [r.cw, r.ch],
  loopSeconds: LOOP_SECONDS,
  fishSeconds: FISH_SECONDS,
  sharks: [lineFrames("classic", sizes[0]!, 9, 1)], // one shark: a finer cell costs too many characters for two
  fish: fishFrames(),
};
writeFileSync(process.argv[2] ?? "capture.json", JSON.stringify(out));
console.log(out.cell, out.sharks.map((s) => [s.kind, Math.round(s.frames.flat().length / s.frames.length)]));
