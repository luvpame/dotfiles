import type { Register } from 'claude-code'

const STYLE = {
  bold: { color: 'red', weight: 'bold' },
  italic: { color: 'magenta', italic: true },
  strike: { color: 'inactive', strikethrough: true },
  code: { color: 'permission' },
  link: { color: 'green', underline: true },
  heading: { color: 'claude', weight: 'bold' },
  listMarker: { color: 'success' },
  quote: { color: 'subtle', italic: true },
} as const

type Block = { kind: 'markdown' | 'styled'; text: string }

const FENCE = /^\s*(```|~~~)/
const LIST = /^(\s*)([-*+]|\d+[.)])\s+/
const HEADING = /^#{1,6}\s+/
const QUOTE = /^>\s?/
// Code comes first so that markers inside it stay literal; bold before italic so
// `**` is not read as two italics. `_x_` needs non-word edges to skip snake_case.
const INLINE =
  /(`[^`\n]+`|\*\*[^*\n]+?\*\*|~~[^~\n]+?~~|\*(?![\s*])[^*\n]+?\*|(?<!\w)_(?!\s)[^_\n]+?_(?!\w)|\[[^\]\n]+\]\([^)\s]+\))/
const SYNTAX = new RegExp(`${INLINE.source}|^(\\s*([-*+]|\\d+[.)])\\s|#{1,6}\\s|>)`, 'm')

// Fences and tables stay with the engine's renderer, since drawing them by hand
// loses highlighting and column layout; so do paragraphs with nothing to color.
export function splitBlocks(text: string): Block[] {
  const paragraphs: string[] = []
  let current: string[] = []
  let inFence = false
  for (const line of text.split('\n')) {
    if (FENCE.test(line)) inFence = !inFence
    if (!inFence && line.trim() === '') {
      if (current.length) paragraphs.push(current.join('\n'))
      current = []
      continue
    }
    current.push(line)
  }
  if (current.length) paragraphs.push(current.join('\n'))

  const blocks: Block[] = []
  for (const p of paragraphs) {
    const kind = SYNTAX.test(p) && !/^\s*(```|~~~|\|)/m.test(p) ? 'styled' : 'markdown'
    const last = blocks.at(-1)
    if (kind === 'markdown' && last?.kind === 'markdown') last.text += `\n\n${p}`
    else blocks.push({ kind, text: p })
  }
  return blocks
}

export const register: Register = on => {
  on('ui.render', { component: 'AssistantMessage' }, ($, e, next) => {
    const blocks = splitBlocks(e.props.text)
    if (e.surface !== 'terminal' || !blocks.some(b => b.kind === 'styled')) return next(e)

    const { Box, Text, Markdown, Link } = $.ui.resolve(e)

    const inline = (text: string): (string | ReturnType<typeof h>)[] =>
      text.split(INLINE).map((part, i) => {
        if (i % 2 === 0) return part
        if (part.startsWith('`')) return <Text {...STYLE.code}>{part.slice(1, -1)}</Text>
        if (part.startsWith('**')) return <Text {...STYLE.bold}>{inline(part.slice(2, -2))}</Text>
        if (part.startsWith('~~')) return <Text {...STYLE.strike}>{inline(part.slice(2, -2))}</Text>
        if (part.startsWith('[')) {
          const [, label = '', href = ''] = /^\[(.+)\]\((.+)\)$/.exec(part) ?? []
          return (
            <Link href={href}>
              <Text {...STYLE.link}>{label}</Text>
            </Link>
          )
        }
        return <Text {...STYLE.italic}>{inline(part.slice(1, -1))}</Text>
      })

    const line = (raw: string) => {
      const heading = HEADING.exec(raw)
      if (heading) return <Text {...STYLE.heading}>{inline(raw.slice(heading[0].length))}</Text>

      const quote = QUOTE.exec(raw)
      if (quote) {
        return (
          <Box flexDirection="row">
            <Text color="subtle">▎ </Text>
            <Text {...STYLE.quote}>{inline(raw.slice(quote[0].length))}</Text>
          </Box>
        )
      }

      const list = LIST.exec(raw)
      if (list) {
        const [marker, indent = '', bullet = ''] = list
        return (
          <Box flexDirection="row">
            <Box width={marker.length} flexShrink={0}>
              <Text>
                {indent}
                <Text {...STYLE.listMarker}>{bullet}</Text>
              </Text>
            </Box>
            <Text>{inline(raw.slice(marker.length))}</Text>
          </Box>
        )
      }

      return <Text>{inline(raw)}</Text>
    }

    // A tree of our own replaces the engine's whole row, its bullet and margin included.
    return (
      <Box flexDirection="row" marginTop={1}>
        <Box width={2} flexShrink={0}>
          <Text color="text">{e.props.isFirstOfReply ? '⏺' : ''}</Text>
        </Box>
        <Box flexDirection="column" flexGrow={1}>
          {blocks.map((b, i) => (
            <Box flexDirection="column" marginTop={i ? 1 : 0}>
              {b.kind === 'markdown' ? <Markdown text={b.text} /> : b.text.split('\n').map(line)}
            </Box>
          ))}
        </Box>
      </Box>
    )
  })
}
