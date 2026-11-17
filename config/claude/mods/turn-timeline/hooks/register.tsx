import { atom, read, update } from 'claude-code'
import type { Register } from 'claude-code'

import type { Board, Status, Tab, Task, Turn } from '../types'

const PANE = 'turn-timeline'
const TITLE = 'タイムライン'
const TOOL = 'mcp__turn-timeline__timeline_tasks'
const EMPTY: Board = { goal: '', startedAt: 0, tasks: [], reports: [] }

const turns = atom({ plugin: 'turn-timeline', key: 'turns' } as const, [], { shape: 'turns-1' })
const board = atom({ plugin: 'turn-timeline', key: 'board' } as const, EMPTY, { shape: 'board-1' })
const tab = atom({ plugin: 'turn-timeline', key: 'tab' } as const, 'tasks')

const STATUSES: readonly Status[] = ['pending', 'in_progress', 'completed']
const LOOK: Record<Status, { glyph: string; label: string; color: string; mark: string }> = {
  completed: { glyph: '●', label: '完了', color: 'success', mark: 'x' },
  in_progress: { glyph: '◐', label: '進行中', color: 'suggestion', mark: '>' },
  pending: { glyph: '○', label: '未着手', color: 'inactive', mark: ' ' },
}

const textOf = (content: unknown): string =>
  typeof content === 'string'
    ? content
    : Array.isArray(content)
      ? content.map(block => (block?.type === 'text' ? String(block.text) : '')).join(' ')
      : ''

const isWide = (char: string) => (char.codePointAt(0) ?? 0) > 0x2e7f

export const fit = (text: string, columns: number): string => {
  let used = 0
  let out = ''
  for (const char of text.replace(/\s+/g, ' ').trim()) {
    used += isWide(char) ? 2 : 1
    if (used > columns - 1) return `${out}…`
    out += char
  }
  return out
}

const two = (n: number) => String(n).padStart(2, '0')
const clock = (at: number) => {
  const date = new Date(at)
  return `${two(date.getHours())}:${two(date.getMinutes())}`
}
const elapsed = (ms: number) => {
  const minutes = Math.floor(ms / 60000)
  return minutes < 60 ? `${minutes}m` : `${Math.floor(minutes / 60)}h${two(minutes % 60)}m`
}

export const progress = (tasks: readonly Task[]): number => {
  const total = tasks.reduce((sum, task) => sum + task.weight, 0)
  const done = tasks.reduce((sum, task) => sum + (task.status === 'completed' ? task.weight : 0), 0)
  return total === 0 ? 0 : done / total
}
const percent = (ratio: number) => `${(ratio * 100).toFixed(1)}%`

// モデルが渡す入力なので、形が違えば理由を返して何も変えない
export const apply = (before: Board, input: { goal?: unknown; ops?: unknown }, now: number): Board | string => {
  if (!Array.isArray(input.ops)) return 'ops は配列で渡す'
  let tasks = [...before.tasks]
  const lines: string[] = []
  for (const op of input.ops as Record<string, unknown>[]) {
    const id = typeof op?.id === 'string' ? op.id : ''
    const at = tasks.findIndex(task => task.id === id)
    const status = op.status as Status | undefined
    if (id === '') return 'op には id が要る'
    if (status !== undefined && !STATUSES.includes(status)) return `status は ${STATUSES.join(' / ')} のどれか: ${id}`
    const weight = op.weight === undefined ? undefined : Number(op.weight)
    if (weight !== undefined && !(weight > 0)) return `weight は正の数: ${id}`
    const note = typeof op.note === 'string' ? op.note : undefined
    if (op.op === 'add') {
      if (at >= 0) return `id が重複している: ${id}`
      if (typeof op.title !== 'string' || op.title.trim() === '') return `add には title が要る: ${id}`
      tasks.push({ id, title: op.title.trim(), weight: weight ?? 1, status: status ?? 'pending', note })
      lines.push(`[+] ${op.title.trim()}`)
    } else if (op.op === 'update') {
      const old = tasks[at]
      if (old === undefined) return `その id のタスクはない: ${id}`
      const next: Task = {
        ...old,
        title: typeof op.title === 'string' && op.title.trim() !== '' ? op.title.trim() : old.title,
        weight: weight ?? old.weight,
        status: status ?? old.status,
        note: note ?? old.note,
      }
      tasks[at] = next
      const moved = next.status === old.status ? '' : ` (${old.status} → ${next.status})`
      lines.push(`[${LOOK[next.status].mark}] ${next.title}${moved}${note ? ` · ${note}` : ''}`)
    } else if (op.op === 'remove') {
      if (at < 0) return `その id のタスクはない: ${id}`
      lines.push(`[-] ${tasks[at]?.title ?? id}`)
      tasks = tasks.filter(task => task.id !== id)
    } else return `op は add / update / remove のどれか: ${id}`
  }
  const head = `進捗 ${percent(progress(before.tasks))} → ${percent(progress(tasks))}`
  return {
    goal: typeof input.goal === 'string' && input.goal.trim() !== '' ? input.goal.trim() : before.goal,
    startedAt: before.tasks.length === 0 ? now : before.startedAt,
    tasks,
    // ponytail: レポートは直近 200 件だけ持つ
    reports: [...before.reports, { at: now, text: [head, ...lines].join('\n') }].slice(-200),
  }
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    await $.command.register({
      name: 'timeline',
      description: 'タスクツリーと進捗、自分の発言の一覧を開く',
    })
    await $.tool.register({
      name: 'timeline_tasks',
      isDeferred: false,
      description:
        '複数の手順がある作業の進み具合を、ユーザーの画面のタイムラインに出す。作業の最初に goal と全タスクを add し、' +
        'タスクを始めるとき in_progress、終えたとき completed に update する。note には決めたことや確かめた結果を1行で書く。',
      inputSchema: {
        type: 'object',
        required: ['ops'],
        properties: {
          goal: { type: 'string', description: '作業全体の名前。最初の呼び出しで渡す' },
          ops: {
            type: 'array',
            items: {
              type: 'object',
              required: ['op', 'id'],
              properties: {
                op: { enum: ['add', 'update', 'remove'] },
                id: { type: 'string', description: '短い英字の名前。例: spec, api' },
                title: { type: 'string' },
                weight: { type: 'number', description: '手間の重み。省略は 1' },
                status: { enum: STATUSES },
                note: { type: 'string' },
              },
            },
          },
        },
      },
    })
    return next(e)
  })

  on('command.run', { command: 'timeline' }, async $ => {
    await $.ui.open({ id: PANE, title: TITLE })
    return { text: 'タイムラインを開いた。' }
  })

  // 自前のツール名は型の一覧にないので、マッチャーと入力の型をここで外す
  on('tool.call', { tool: TOOL as never }, async ($, e: unknown) => {
    const input = e as { goal?: unknown; ops?: unknown }
    const answer = apply(await read($, board), input, Date.now())
    if (typeof answer === 'string') return { deny: answer }
    // 同じ入力を読み直して当てるので、押下と重なっても取りこぼさない
    await update($, board, held => {
      const again = apply(held, input, Date.now())
      return typeof again === 'string' ? held : again
    })
    void $.ui.open({ id: PANE, title: TITLE })
    const tree = answer.tasks.map(task => `- [${LOOK[task.status].mark}] ${task.id}: ${task.title} (w=${task.weight})`)
    return { result: [answer.reports.at(-1)?.text ?? '', '', answer.goal, ...tree].join('\n') }
  })

  // 応答中に送った発言は prompt ではなく delivery で届く。
  // 入口で絞らず全行を聞くと、別プラグインが先に流した行でこのフックがスキップされ、その通知がモデルにも届く
  for (const door of ['prompt', 'delivery'] as const) on('session.append', { door }, async ($, e, next) => {
    const text = textOf(e.message.content).trim()
    const isTyped = e.origin.kind === 'composer' || e.origin.kind === 'bridge'
    if (isTyped && e.agentId === undefined && !e.message.isMeta && text !== '') {
      const turn: Turn = { id: e.uuid, at: Date.now(), text: text.slice(0, 300) }
      // ponytail: 直近 500 件だけ持つ。足りなくなったら絞り込みを足す
      await update($, turns, list => [...list, turn].slice(-500))
    }
    return next(e)
  })

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    const { tasks } = await read($, board)
    if (e.props.hasSurvey || tasks.length === 0) return next(e)
    const { Box, Button, Text } = $.ui.resolve(e)
    const cells = 20
    const total = tasks.reduce((sum, task) => sum + task.weight, 0)
    const share = (status: Status) =>
      Math.round((cells * tasks.reduce((sum, task) => sum + (task.status === status ? task.weight : 0), 0)) / total)
    const done = share('completed')
    const doing = Math.min(cells - done, share('in_progress'))
    const current = tasks.find(task => task.status === 'in_progress')

    return (
      <Box>
        <Text>
          {TITLE} {percent(progress(tasks))}{' '}
          <Text backgroundColor="success">{' '.repeat(done)}</Text>
          <Text backgroundColor="suggestion">{' '.repeat(doing)}</Text>
          <Text backgroundColor="inactive">{' '.repeat(cells - done - doing)}</Text>
          {current ? ` ▶ ${fit(current.title, 30)} ` : ' '}
        </Text>
        <Button key="open" label="開く" onPress={() => void $.ui.open({ id: PANE, title: TITLE })} />
      </Box>
    )
  })

  on('ui.render', { component: 'Pane', requestId: PANE }, async ($, e) => {
    const { Box, Text, Button, Progress } = $.ui.resolve(e)
    const columns = e.props.bodyColumns ?? 40
    const shown = await read($, tab)
    const held = await read($, board)
    const list = await read($, turns)
    const { tasks } = held
    const ratio = progress(tasks)
    const doneCount = tasks.filter(task => task.status === 'completed').length
    const current = tasks.find(task => task.status === 'in_progress') ?? tasks.find(task => task.status === 'pending')
    const overall: Status = tasks.length > 0 && doneCount === tasks.length ? 'completed' : current ? 'in_progress' : 'pending'
    const badge = (status: Status) => (
      <Text backgroundColor={LOOK[status].color} color="inverseText">
        {` ${LOOK[status].label} `}
      </Text>
    )
    const tabs: [Tab, string, string][] = [
      ['tasks', '1', `タスク ${doneCount}/${tasks.length}`],
      ['reports', '2', `レポート ${held.reports.length}`],
      ['turns', '3', `発言 ${list.length}`],
    ]

    return (
      <Box flexDirection="column">
        <Box gap={2}>
          {tabs.map(([name, hotkey, label]) => (
            <Button key={`tab:${name}`} plain hotkey={hotkey} onPress={() => update($, tab, () => name)}>
              <Text bold={shown === name} underline={shown === name} dimColor={shown !== name}>
                {label}
              </Text>
            </Button>
          ))}
        </Box>
        <Text> </Text>

        {shown === 'tasks' && tasks.length === 0 && (
          <Text dimColor>タスクはまだない。手順のある作業を頼むと、Claude がここに進み具合を出す。</Text>
        )}
        {shown === 'tasks' && tasks.length > 0 && (
          <Box flexDirection="column">
            <Box justifyContent="center">
              <Text bold>{fit(held.goal || '作業', columns - 2)}</Text>
            </Box>
            <Box flexDirection="column" borderStyle="round" paddingX={1}>
              <Box justifyContent="space-between">
                <Text bold>進捗</Text>
                {badge(overall)}
              </Box>
              <Progress label="全体" value={ratio} valueText={percent(ratio)} color="success" />
              <Box justifyContent="space-between">
                <Text dimColor>
                  {doneCount}/{tasks.length} 件のタスクが完了
                </Text>
                <Text dimColor>経過時間: {elapsed(Date.now() - held.startedAt)}</Text>
              </Box>
              {current && (
                <Button
                  key="continue"
                  variant="primary"
                  label="▷ 続行を依頼"
                  onPress={() => void $.prompt.submit({ text: `「${current.title}」から続けて`, asUser: true })}
                />
              )}
            </Box>
            {tasks.map(task => (
              <Box flexDirection="column">
                <Box justifyContent="space-between">
                  <Text>
                    <Text color={LOOK[task.status].color}>{LOOK[task.status].glyph} </Text>
                    {fit(task.title, columns - 12)}
                  </Text>
                  <Text dimColor={task.status !== 'completed'}>{task.status === 'completed' ? '100%' : '0%'}</Text>
                </Box>
                <Text>
                  {'  '}
                  {badge(task.status)}
                  {task.note ? <Text dimColor> {fit(task.note, columns - 12)}</Text> : ''}
                </Text>
              </Box>
            ))}
          </Box>
        )}

        {shown === 'reports' && held.reports.length === 0 && <Text dimColor>レポートはまだない。</Text>}
        {shown === 'reports' &&
          [...held.reports].reverse().map(report => (
            <Box flexDirection="column" borderStyle="round" paddingX={1}>
              <Text dimColor>{clock(report.at)}</Text>
              <Text>{report.text}</Text>
            </Box>
          ))}

        {shown === 'turns' && list.length === 0 && <Text dimColor>このセッションの発言はまだない。</Text>}
        {shown === 'turns' &&
          list.map(turn => (
            <Button
              key={turn.id}
              plain
              onPress={async () => {
                const moved = await $.ui.scroll({ to: { requestId: turn.id }, block: 'start' })
                if (moved.deny) void $.ui.toast(`移動できない: ${moved.deny}`)
              }}
            >
              <Text dimColor>{clock(turn.at)} </Text>
              {fit(turn.text, columns - 6)}
            </Button>
          ))}
      </Box>
    )
  })
}
