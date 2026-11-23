import { makeColors } from './make-colors.js'

// ascii-sharks' ACCENTS, pulled toward grey for a quiet daylight look.
export const { theme, problems } = makeColors({
  label: 'ASCII Sharks Light',
  only: 'light',
  roles: { accent: '#4a5fa8', danger: '#b0473f', success: '#4f8a55', warning: '#a8743a', pro: '#8a5fa3' },
  light: {
    gray: {
      anchors: {
        'surface-0': '#e9edf0',
        'surface-1': '#eef1f3',
        'surface-2': '#f4f6f7',
        'surface-3': '#f4f6f7',
        'text-primary': '#1d2630',
        'text-secondary': '#3c4855',
        'text-muted': '#56626e',
      },
    },
  },
})
