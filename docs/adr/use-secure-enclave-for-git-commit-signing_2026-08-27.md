# Git commit署名にSecure Enclaveを使う

Date: 2026-08-27

## Status

Accepted

## Context

現在のGit commit署名は1Password SSH Agentを使っている。
1Passwordは署名のたびに生体認証を要求するため、Coding Agentが人間の操作を待てずにcommit処理を中断することがある。

署名鍵をファイルとして置けば生体認証は不要になるが、秘密鍵を端末から取り出せる状態になる。
macOSのSecure Enclaveは秘密鍵を非エクスポートとして保持でき、OpenSSHから署名に使える。

## Decision

Git commitの署名鍵だけをSecure Enclaveへ移す。
tag署名は変更せず、GitHubへのpushとpullに使うSSH認証は1Password SSH Agentに残す。

各Macで次のCTK identityを生成する。

```text
sc_auth create-ctk-identity -l git-sign -k p-256-ne -t none
```

`p-256-ne`はP-256の非エクスポート鍵を指定する。
`-t none`はTouch IDやパスコードを要求しない保護方法であり、Coding Agentが人間の入力なしにcommitへ署名できるようにする。
この選択により、ログイン中のユーザーとして動くプロセスは署名を依頼できる。
Secure Enclaveは秘密鍵の取り出しを防ぐが、侵害済みのユーザーセッションから署名操作を隠す仕組みではない。

OpenSSHが使う参照ファイルは各Macの `~/.ssh/id_git_sign` と `~/.ssh/id_git_sign.pub` に置く。
`config/git/ssh-sign` は `/usr/lib/ssh-keychain.dylib` を `SSH_SK_PROVIDER` に設定し、システムの `ssh-keygen`を実行する。
参照ファイルは共有せず、端末ごとに生成する。

リポジトリの `script/setup-git-signing.sh` は、既存の鍵一式とCTK identityが正常なら再利用し、片方だけのファイル、参照不能な鍵、公開鍵とCTK identityの不一致、曖昧なCTK状態を検出したら停止する。
新規作成時も既存ファイルを上書きせず、一時ディレクトリで `ssh-keygen -w /usr/lib/ssh-keychain.dylib -K -N ""` を実行してから配置する。
GitHubへの登録はデフォルトではコマンドを表示するだけとし、`--register-github`を指定した場合だけ確認後に実行する。
登録タイトルは複数のMacを区別できるよう `git-sign@<short-hostname>` とし、ホスト名を取得できない場合は `git-sign` に戻す。
再実行時の登録済み判定はタイトルではなく公開鍵の内容で行う。

移行は二段階で行う。
最初にwizardで鍵を生成し、一時リポジトリで署名を検証してからGitHubへ公開鍵を登録する。
この段階では共有Git設定を変更せず、1Passwordによる現行の署名経路を維持する。
GitHub上で新しい鍵によるcommitが `Verified` になったことを確認した後、共有Git設定の署名鍵と署名プログラムをSecure Enclave用へ切り替える。
確認後に旧1Password Signing keyのGitHub登録だけを削除する。
1PasswordのSSH認証鍵は削除しない。

ローカルの恒常的な `allowedSignersFile` は管理しない。
wizardが一時ファイルへ現在の公開鍵だけを書き、一時Git repositoryの署名commitを `git verify-commit` で検証してから、両方を削除する。

## Options Considered

- **1Passwordによる署名を維持する**：秘密鍵の操作に生体認証を要求できるが、Coding Agentの無人commitが認証待ちで止まる。
- **通常のファイル鍵へ移す**：無人署名はできるが、秘密鍵を端末から持ち出せる。
- **Secure Enclave鍵を `-t bio` で使う**：秘密鍵を非エクスポートにできるが、署名のたびに生体認証が必要になり、移行の目的を満たさない。
- **Secure Enclave鍵を `-t none` でcommit署名に使う**：秘密鍵を非エクスポートに保ちながら無人commitを許可できる。
  pushとpullの認証は1Passwordに残すため、Coding Agentへpush権限まで自動的に渡さない。

## Consequences

Coding Agentは生体認証を待たずにcommitへ署名できる。
Secure Enclaveの秘密鍵は端末外へ持ち出せないが、公開鍵と鍵ハンドルはMacごとに異なるため、各Macの公開鍵をGitHubへ別々に登録する必要がある。

`-t none`により、ログイン中のユーザー権限を得たマルウェアやプロセスはcommit署名を依頼できる。
pushとpullは引き続き1Password SSH Agentを使う。

GitHubの新しい `Verified` commitを確認する前に旧Signing keyを削除しない。
確認後に旧Signing keyを削除しても、検証済みcommitの表示は維持される。

ローカルの `git verify-commit` は恒常的な信頼鍵名簿を持たないため、wizardの一時検証以外ではGitHubの `Verified` 表示を使う。

## References

- [Secure Enclave で git commit の署名鍵を管理する](https://www.mizdra.net/entry/2026/08/07/101542)
- [sc_auth(8)](https://keith.github.io/xcode-man-pages/sc_auth.8.html)
- [GitHub CLI: gh ssh-key add](https://cli.github.com/manual/gh_ssh-key_add)
