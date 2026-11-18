import type { Register, ThemeSetArgs } from 'claude-code'

import { problems, theme } from './look.ts'
import { SCENE } from './scene.ts'

const LOOK: ThemeSetArgs = { colors: theme, backdrop: { scene: 'ascii-sharks', glass: {} } }

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    const unpainted = problems.find(line => line.startsWith("Desktop won't paint"))
    if (unpainted !== undefined) {
      $.ui.toast(unpainted)
    }
    const set = await $.theme.set(LOOK)
    if (!set.isDrawn) {
      $.ui.status(set.reason)
    }
    return next(e)
  })

  on('ui.render', { component: 'Backdrop' }, ($, e, next) => {
    if (e.surface !== 'desktop' && e.surface !== 'mobile') {
      return next(e)
    }
    const { Svg } = $.ui.resolve(e)
    return <Svg source={SCENE} alt="ASCII art sharks and a school of fish swimming across a pale grid" isInteractive />
  })
}
