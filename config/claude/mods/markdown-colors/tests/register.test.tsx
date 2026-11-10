import { expect, test } from 'claude-code/testing'

const MESSAGE = (text: string) =>
  ({
    plugin: 'markdown-colors',
    component: 'AssistantMessage',
    requestId: 'm1',
    surface: 'terminal',
    props: { text, isFirstOfReply: true },
  }) as const

test('bold text is drawn red and bold', async ($, on) => {
  on('ui.render', ($, e) => {
    const { Text } = $.ui.resolve(e)
    return <Text>engine</Text>
  })

  const ui = await $.ui.mount(MESSAGE('前置き\n\nこれは **大事** と `code` です\n\n```\n**fence**\n```'))

  const bold = (await ui.findAll({ type: 'Text' })).find(t => t.text === '大事')
  expect(bold?.props.color).toBe('red')
  expect(bold?.props.weight).toBe('bold')
  expect((await ui.find({ type: 'Markdown', text: /前置き/ }))?.type).toBe('Markdown')
  expect((await ui.find({ type: 'Markdown', text: /fence/ }))?.type).toBe('Markdown')
  expect(await ui.find({ type: 'Text', text: /engine/ })).toBeUndefined()
  await ui.unmount()
})

test('a reply with nothing to color is left to the engine', async ($, on) => {
  on('ui.render', ($, e) => {
    const { Text } = $.ui.resolve(e)
    return <Text>engine</Text>
  })

  const ui = await $.ui.mount(MESSAGE('ふつうの文'))

  expect((await ui.find({ type: 'Text', text: /engine/ }))?.text).toBe('engine')
  await ui.unmount()
})

test('each syntax gets its own color', async ($, on) => {
  on('ui.render', ($, e) => {
    const { Text } = $.ui.resolve(e)
    return <Text>engine</Text>
  })

  const ui = await $.ui.mount(
    MESSAGE('## 見出し\n\n- *斜体* と ~~消し~~ と [リンク](https://example.com)\n- snake_case_name\n\n> 引用'),
  )
  const texts = await ui.findAll({ type: 'Text' })
  const styleOf = (text: string) => texts.findLast(t => t.text === text)?.props

  expect(styleOf('見出し')?.color).toBe('claude')
  expect(styleOf('-')?.color).toBe('success')
  expect(styleOf('斜体')?.color).toBe('magenta')
  expect(styleOf('消し')?.strikethrough).toBe(true)
  expect(styleOf('リンク')?.underline).toBe(true)
  expect(styleOf('引用')?.italic).toBe(true)
  expect(texts.some(t => t.text === 'case')).toBe(false)
  expect((await ui.find({ type: 'Link' }))?.props.href).toBe('https://example.com')
  await ui.unmount()
})
