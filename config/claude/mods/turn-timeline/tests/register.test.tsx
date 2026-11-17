import { expect, test } from 'claude-code/testing'

import { apply, progress } from '../hooks/register'

const PANE = {
  plugin: 'turn-timeline',
  component: 'Pane',
  requestId: 'turn-timeline',
  surface: 'terminal',
  props: {
    title: 'タイムライン',
    isFocused: false,
    bodyColumns: 40,
    placement: 'dock',
    scroll: { offset: 0, bodyRows: 20 },
    view: {},
  },
} as const

test('the turns tab lists the prompts of the main conversation, and nothing else', async ($, on) => {
  const row = (door: 'prompt' | 'response', uuid: string, text: string, agentId?: string) =>
    $.session.append({
      door,
      uuid,
      agentId,
      origin: { kind: 'composer' },
      message: { type: 'user', role: 'user', content: [{ type: 'text', text }] },
    } as never)

  await row('prompt', 'u1', 'first   question\nwith a second line')
  await row('response', 'u2', 'an answer')
  await row('prompt', 'u3', 'a subagent prompt', 'agent-1')

  const ui = await $.ui.mount(PANE)
  await ui.press({ key: 'tab:turns' })
  const turn = await ui.find({ type: 'Button', key: 'u1' })
  expect(turn?.text).toMatch(/first question with a second line/)
  expect(await ui.find({ type: 'Button', key: 'u3' })).toBeUndefined()
  await ui.unmount()
})

test('progress is the completed share of the weights, and a bad op changes nothing', () => {
  const empty = { goal: '', startedAt: 0, tasks: [], reports: [] }
  const added = apply(
    empty,
    {
      goal: 'move',
      ops: [
        { op: 'add', id: 'spec', title: 'Spec', weight: 1 },
        { op: 'add', id: 'board', title: 'Board', weight: 4 },
      ],
    },
    1000,
  )
  if (typeof added === 'string') throw new Error(added)
  expect(added.startedAt).toBe(1000)

  const done = apply(added, { ops: [{ op: 'update', id: 'spec', status: 'completed', note: 'keys decided' }] }, 2000)
  if (typeof done === 'string') throw new Error(done)
  expect(progress(done.tasks)).toBe(0.2)
  expect(done.reports.at(-1)?.text).toMatch(/進捗 0\.0% → 20\.0%\n\[x\] Spec \(pending → completed\) · keys decided/)

  expect(typeof apply(done, { ops: [{ op: 'update', id: 'nope', status: 'completed' }] }, 3000)).toBe('string')
  expect(typeof apply(done, { ops: [{ op: 'update', id: 'spec', status: 'finished' }] }, 3000)).toBe('string')
})
