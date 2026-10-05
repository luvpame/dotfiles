import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { Link } from '../types'

const PANE = 'session-links'
const links = atom({ plugin: 'session-links', key: 'links' } as const, [])
// Markdown の [title](url) を先に試し、合わなければ裸の URL として拾う
const LINK_RE = /\[([^\]\n]+)\]\((https?:\/\/[^\s)]+)\)|https?:\/\/[^\s<>"'`|\\]+/g

const extract = (text: string): Link[] =>
  [...text.matchAll(LINK_RE)].map(m =>
    m[2] ? { url: m[2], title: m[1].trim() } : { url: m[0].replace(/[.,;:!?)\]}>*_]+$/, '') },
  )

async function refresh($: EngineInterface) {
  const found: Link[] = []
  // メイン会話の本文だけを見る。ツールの入出力と、本文に差し込まれる system-reminder は除く
  for (const m of await $.session.messages()) {
    found.push(...extract(m.text.replace(/<system-reminder>[\s\S]*?<\/system-reminder>/g, '')))
  }
  // 新しいものを上に、重複は最新の位置に寄せ、どこかでタイトルが付いていればそれを使う
  const byUrl = new Map<string, Link>()
  for (const link of found.reverse()) {
    const seen = byUrl.get(link.url)
    if (!seen) byUrl.set(link.url, link)
    else if (!seen.title && link.title) seen.title = link.title
  }
  await update($, links, () => [...byUrl.values()])
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    await $.command.register({ name: 'links', description: 'Toggle the links sidebar' })
    await refresh($)
    void $.ui.open({ id: PANE, title: 'Links' })
    return next(e)
  })

  on('command.run', { command: 'links' }, async $ => {
    const pane = (await $.ui.panes()).find(p => p.id === PANE)
    if (pane?.isPlaced) {
      await $.ui.close({ id: PANE })
      return { text: 'Links sidebar closed.' }
    }
    await refresh($)
    await $.ui.open({ id: PANE, title: 'Links' })
    return { text: 'Links sidebar opened.' }
  })

  on('turn.complete', async ($, e, next) => {
    const done = await next(e)
    if (e.agentId === undefined) await refresh($)
    return done
  })

  on('ui.render', { component: 'Pane', requestId: PANE }, async ($, e) => {
    const { Box, Text, Button } = $.ui.resolve(e)
    const list = await read($, links)
    let room = Math.max(1, (e.viewport?.rows ?? 24) - 2)
    const shown = list.filter(link => (room -= link.title ? 2 : 1) >= 0)

    return (
      <Box flexDirection="column">
        {list.length === 0 && <Text dimColor>No links yet.</Text>}
        {shown.map(link => (
          <Box key={link.url} flexDirection="row" gap={1}>
            <Button onPress={() => void $.process.run(['open', link.url])}>Open</Button>
            <Box flexDirection="column" flexShrink={1}>
              {link.title && <Text bold wrap="truncate-end">{link.title}</Text>}
              <Text dimColor={!!link.title} wrap="truncate-end">{link.url}</Text>
            </Box>
          </Box>
        ))}
      </Box>
    )
  })
}
