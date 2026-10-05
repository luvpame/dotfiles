export type Link = { url: string; title?: string }

declare module 'claude-code' {
  interface PluginState {
    'session-links': { links: Link[] }
  }
}
