import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register, SessionRateLimit } from 'claude-code'

import type { Jobs, Limit } from '../types'

const limits = atom({ plugin: 'usage-band', key: 'limits' } as const, {})
const jobs = atom({ plugin: 'usage-band', key: 'jobs' } as const, { running: 0, done: 0 })
// サブエージェントは $.agent.list() で数え、それ以外のバックグラウンド作業はツール呼び出しから拾う
const BG_TOOLS = ['Bash', 'Monitor', 'Workflow']
const isBackground = (tool: string, input: Record<string, unknown>) =>
  tool === 'Bash' ? input.run_in_background === true : BG_TOOLS.includes(tool)

async function refreshJobs($: EngineInterface) {
  const started: string[] = []
  const ended = new Set<string>()
  for (const m of await $.session.messages()) {
    for (const u of m.toolUses) if (isBackground(u.tool, u.input) && !u.isError) started.push(u.tool_use_id)
    // 終了したバックグラウンド作業は <task-notification> の <tool-use-id> で届く
    if (m.role === 'user') for (const x of m.text.matchAll(/<tool-use-id>([^<]+)<\/tool-use-id>/g)) ended.add(x[1]!)
  }
  const agents = (await $.agent.list()).filter(a => !a.parentId)
  const agentsRunning = agents.filter(a => a.status === 'running').length
  const shellsRunning = started.filter(id => !ended.has(id)).length
  await update($, jobs, () => ({
    running: shellsRunning + agentsRunning,
    done: started.length - shellsRunning + agents.length - agentsRunning,
  }))
}

const setLimits = ($: EngineInterface, rl: SessionRateLimit[]) =>
  update($, limits, () => Object.fromEntries(rl.map(l => [l.kind, { percentUsed: l.percentUsed, resetsAt: l.resetsAt }])))

const pad = (n: number) => String(n).padStart(2, '0')
const resetLabel = (iso: string | undefined, withDate: boolean) => {
  if (!iso) return ''
  const d = new Date(iso)
  const time = `${d.getHours()}:${pad(d.getMinutes())}`
  return ` ↻${withDate ? `${d.getMonth() + 1}/${d.getDate()} ` : ''}${time}`
}
const colorOf = (p: number) => (p >= 90 ? 'red' : p >= 70 ? 'yellow' : undefined)

// ゲージは前回値から今回値へ伸び縮みさせる。同じ値の再描画では source を変えず、アニメーションを再生し直さない
const anim = new Map<string, { from: number; to: number }>()
const sweep = (kind: string, to: number) => {
  const a = anim.get(kind)
  if (a?.to !== to) anim.set(kind, { from: a?.to ?? 0, to })
  return anim.get(kind)!
}

const BAR = 132
const GAUGE = 156
const fill = (p: number) => (p >= 90 ? 'url(#hot)' : p >= 70 ? 'url(#warm)' : 'url(#cool)')

function gauge(x: number, label: string, kind: string, w: Limit, withDate: boolean) {
  const p = Math.min(100, w.percentUsed)
  const { from, to } = sweep(kind, p)
  const px = (v: number) => Math.max(6, (BAR * v) / 100).toFixed(1)
  const pulse = p >= 90 ? '<animate attributeName="opacity" values="1;.45;1" dur="1.6s" repeatCount="indefinite"/>' : ''
  return `<g transform="translate(${x},0)">
  <text x="0" y="17" class="tiny">${label}</text>
  <text x="20" y="17" class="big">${Math.round(p)}<tspan class="unit">%</tspan></text>
  <text x="${BAR}" y="17" class="dim" text-anchor="end">${resetLabel(w.resetsAt, withDate).trim()}</text>
  <rect x="0" y="26" width="${BAR}" height="7" rx="3.5" class="bar"/>
  <rect x="0" y="26" width="${px(to)}" height="7" rx="3.5" fill="${fill(p)}">
    <animate attributeName="width" from="${px(from)}" to="${px(to)}" dur="1.1s" calcMode="spline" keySplines=".22 1 .36 1" keyTimes="0;1" fill="freeze"/>${pulse}
  </rect>
</g>`
}

function jobsChip(x: number, j: Jobs) {
  const live = j.running > 0
  const icon = live
    ? `<circle cx="14" cy="22" r="8" class="track" stroke-width="2.5"/>
  <circle cx="14" cy="22" r="8" fill="none" stroke="url(#cool)" stroke-width="2.5" stroke-linecap="round" stroke-dasharray="14 50">
    <animateTransform attributeName="transform" type="rotate" from="0 14 22" to="360 14 22" dur=".9s" repeatCount="indefinite"/>
  </circle>`
    : `<path d="M8 22.5l4 4 8-9" fill="none" stroke="url(#cool)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"
    stroke-dasharray="20" stroke-dashoffset="20"><animate attributeName="stroke-dashoffset" to="0" dur=".5s" fill="freeze"/></path>`
  return `<g transform="translate(${x},0)">
  <rect x="0" y="6" width="150" height="32" rx="16" class="chip"/>
  ${icon}
  <text x="30" y="20" class="big small">${j.running}<tspan class="unit"> 実行中</tspan></text>
  <text x="30" y="33" class="dim">✓ ${j.done} 完了</text>
</g>`
}

function bandSvg(shown: [string, string, Limit, boolean][], j: Jobs) {
  const parts = shown.map(([label, kind, w, withDate], i) => gauge(i * GAUGE, label, kind, w, withDate))
  const width = shown.length * GAUGE + (j.running + j.done > 0 ? 154 : 0)
  if (j.running + j.done > 0) parts.push(jobsChip(shown.length * GAUGE, j))
  return {
    width,
    source: `<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="44" viewBox="0 0 ${width} 44">
<style>
  text { font-family: -apple-system, system-ui, sans-serif; fill: #1f1e1d }
  .big { font-size: 15px; font-weight: 650; font-variant-numeric: tabular-nums }
  .small { font-size: 13px }
  .unit { font-size: 10px; font-weight: 500; opacity: .6 }
  .dim { font-size: 10px; opacity: .55 }
  .tiny { font-size: 11px; font-weight: 600; opacity: .6 }
  .track { fill: none; stroke: #00000014; stroke-width: 4 }
  .bar { fill: #00000012 }
  .chip { fill: #0000000a; stroke: #00000012 }
  @media (prefers-color-scheme: dark) {
    text { fill: #f5f4ef } .bar { fill: #ffffff1a } .track { stroke: #ffffff1c } .chip { fill: #ffffff0d; stroke: #ffffff17 }
  }
</style>
<defs>
  <linearGradient id="cool" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#5eb3ff"/><stop offset="1" stop-color="#8b6cff"/></linearGradient>
  <linearGradient id="warm" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ffc24b"/><stop offset="1" stop-color="#ff8a3d"/></linearGradient>
  <linearGradient id="hot" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ff6b5e"/><stop offset="1" stop-color="#e5307a"/></linearGradient>
</defs>
${parts.join('\n')}
</svg>`,
  }
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    await setLimits($, (await $.session.usage()).rateLimits)
    await refreshJobs($)
    return next(e)
  })

  on('session.measure', async ($, e, next) => {
    if (e.changed.includes('rateLimits')) await setLimits($, e.rateLimits)
    return next(e)
  })

  on('tool.call', async ($, e, next) => {
    const done = await next(e)
    if (e.tool === 'Agent' || e.tool === 'TaskStop' || isBackground(e.tool, e)) await refreshJobs($)
    return done
  })

  on('turn.complete', async ($, e, next) => {
    const done = await next(e)
    await refreshJobs($)
    return done
  })

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    if (e.props.hasSurvey) return next(e)
    const l = await read($, limits)
    const j = await read($, jobs)
    const windows: [string, Limit | undefined, boolean][] = [['5h', l.five_hour, false], ['1w', l.seven_day, true]]
    const shown = windows.filter((w): w is [string, Limit, boolean] => !!w[1])
    if (shown.length === 0 && j.running + j.done === 0) return next(e)

    const els = $.ui.resolve(e)
    // Svg を持つ面（Desktop）ではアニメーション付きの帯、持たない面（ターミナル）では文字の帯
    if ('Svg' in els) {
      const { Svg } = els
      const kinds: Record<string, string> = { '5h': 'five_hour', '1w': 'seven_day' }
      const { width, source } = bandSvg(shown.map(([label, w, d]) => [label, kinds[label]!, w, d]), j)
      const alt = [...shown.map(([label, w]) => `${label} ${Math.round(w.percentUsed)}%`), `${j.running} 実行中 ${j.done} 完了`].join(', ')
      return <Svg source={source} alt={alt} width={width} height={44} isInteractive />
    }

    const { Box, Text } = els

    return (
      <Box flexDirection="row" gap={2}>
        {shown.map(([label, w, withDate]) => (
          <Text key={label} color={colorOf(w.percentUsed)} dimColor={!colorOf(w.percentUsed)}>
            {label} {Math.round(w.percentUsed)}%{resetLabel(w.resetsAt, withDate)}
          </Text>
        ))}
        {j.running + j.done > 0 && (
          <Text dimColor={j.running === 0} color={j.running > 0 ? 'cyan' : undefined}>
            ▶ {j.running} 実行中 · ✓ {j.done} 完了
          </Text>
        )}
      </Box>
    )
  })
}
