export type Limit = { percentUsed: number; resetsAt?: string }
export type Jobs = { running: number; done: number }

declare module 'claude-code' {
  interface PluginState {
    'usage-band': { limits: Record<string, Limit>; jobs: Jobs }
  }
}
