# Dotfiles

個人の開発環境を宣言的に管理し、複数のツールで一貫した操作体験を保つ。

## Language

**Agent Git summary**:
検出された agent pane の checkout を対象として、branch、変更行数、関連する pull request の状態をまとめた sidebar 表示。
_Avoid_: Git status, agent status

**ローカルスキル**:
この dotfiles で内容を編集し、利用するエージェントへ配布するスキル。
_Avoid_: インストール済みスキル（取得元を区別できない）

**外部スキル**:
この dotfiles の外にある配布元から取得し、利用するエージェントへ配布するスキル。
_Avoid_: プラグイン（スキル以外の機能も含み得る）
