export type Turn = { id: string; at: number; text: string }

export type Status = 'pending' | 'in_progress' | 'completed'
export type Task = { id: string; title: string; weight: number; status: Status; note?: string }
export type Report = { at: number; text: string }
export type Board = { goal: string; startedAt: number; tasks: Task[]; reports: Report[] }
export type Tab = 'tasks' | 'reports' | 'turns'

declare module 'claude-code' {
  interface PluginState {
    'turn-timeline': { turns: Shaped<Turn[]>; board: Shaped<Board>; tab: Tab }
  }
}
