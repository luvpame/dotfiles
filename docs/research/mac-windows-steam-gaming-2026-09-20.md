# MacでWindows専用のSteamゲームを遊ぶ方法

調査日: 2026-09-20。
対象機は実機情報で確認したMacBook Air（Apple M2、メモリ16 GB、macOS 26.6.2）。
製品の公式サイト、公式サポート、開発元のリポジトリを調査した。
ゲーム名が未指定のため、個別タイトルの動作保証やFPSの実測は含まない。
この調査ではソフトのインストール、購入、OS変更は行っていない。

## このMacで選ぶ順序

推奨順は、以下の仕様と制約を踏まえた判断である。

1. ゲームを動かせるWindows PCを持っているなら、無料のSteam Remote Playを試す。
2. PCがなく、遊びたいゲームのSteam版がGeForce NOWに対応していれば、無料枠で回線を試す。
3. Mac内で動かしたい場合は、CrossOverの14日試用で対象ゲームを確認する。
4. 無料のローカル環境を優先するなら、Porting Kitのゲーム別設定を探す。
5. Windows自体も必要なら、ParallelsまたはVMware Fusionを検討する。

Mac版Steamには、Windows専用ゲーム全般を起動できる標準機能はない。
互換ソフトを使う場合は、その環境内にWindows版Steamを入れてゲームを起動する。
ValveのProtonはLinux向けであり、macOS版Steamに設定を追加するだけでは使えない。[SteamのOS対応案内](https://help.steampowered.com/en/faqs/view/29ED-68C9-0171-2BA8)、[CrossOverへのSteam導入](https://support.codeweavers.com/en_US/installing-steam-in-crossover)、[Valve Proton](https://github.com/ValveSoftware/Proton)

## 方法の比較

費用はゲーム代を含まない。
有料製品の日本円価格を一次資料から確定できなかった場合は、推定額を記載していない。
各行の仕様の出典と詳しい制約は後続の説明に示す。

| 方法 | ゲームを実行する場所 | 追加費用 | このMacでの位置づけ |
| --- | --- | --- | --- |
| CrossOver | Mac内のWindows互換環境 | 有料、14日試用 | ローカル実行の第一候補。ゲームごとの確認が必要 |
| Porting Kit | Mac内のWine環境 | 無料 | ゲーム別の設定があるタイトルで試す |
| Sikarugir、Wine直接構築 | Mac内のWine環境 | 無料 | 自分で設定や不具合対応をする人向け |
| Game Porting Toolkit | Mac内の評価環境 | ツール配布あり | 開発者向け。ゲーム用ランチャーとしての手軽さは劣る |
| Whisky | Mac内のWine環境 | 無料 | 本家は開発停止。新規導入の推奨から外す |
| GameHub、Mythic、Merlot | Mac内のWine系環境 | 製品による | 公開ベータ、アルファ、コミュニティ実装として個別評価 |
| Parallels＋Windows 11 Arm | Mac内の仮想Windows | 有料＋Windowsライセンス | DX11以前が中心。Windowsアプリも必要な場合 |
| VMware Fusion＋Windows 11 Arm | Mac内の仮想Windows | Fusion無料、Windows別途 | 無料の仮想化候補。DX11対応 |
| UTM | Mac内の仮想Windowsなど | Web配布版無料、Windows別途 | Windows 3D対応は5系ベータの実験枠 |
| GeForce NOW | NVIDIAのクラウド | 無料枠／有料プラン | 重いゲームの有力候補。対象タイトルと回線次第 |
| Steam Remote Play／Steam Link | 別のゲーム用PC | ソフト無料 | Windows PCがあるなら最初に試す |
| Sunshine＋Moonlight、Parsec | 別のゲーム用PC | 無料利用可 | 配信設定やSteam以外の用途も必要な場合 |
| Boosteroid、Shadow PC | 海外のクラウド | 有料 | 日本向け提供地域や接続品質の制約があり優先度は低い |
| Asahi Linux＋Proton | MacをLinuxで起動 | 無料 | OS導入を伴う上級者向け |
| Boot Camp | MacをWindowsで起動 | Windowsなど | Intel Mac限定。M2では使えない |

## Mac内で動かす互換ソフト

### CrossOver

**CrossOver**はWindowsを丸ごとインストールせず、WindowsアプリをMac上で実行する製品である。
Windowsのライセンスは不要。
公式のSteamインストーラーを選ぶと、必要な環境をまとめて作れる。[製品説明](https://www.codeweavers.com/crossover/)、[Steam導入手順](https://support.codeweavers.com/en_US/installing-steam-in-crossover)

CrossOver 26の描画設定には、DirectX 11向けのDXMTと、DirectX 11／12向けのD3DMetalがある。
Auto設定はゲームごとのデータベースに従って方式を選ぶ。
まずAutoで試し、不具合があるときだけ対象ゲームの設定例を確認するのがよい。
「DirectX 12対応」は、そのAPIを使う全ゲームが動く保証ではない。[公式の描画設定](https://support.codeweavers.com/en_US/advanced-settings-in-crossover-mac-26)

調査時の公式ストア表示は、CrossOver＋が74米ドル、Lifeが494米ドル。
前者には12か月の更新とサポート、後者には無期限の更新とサポートが付く。
地域、税、割引による最終価格は購入画面で確認する。
14日間の完全機能の試用があるため、購入前に目的のゲームで試す。[公式ストア](https://www.codeweavers.com/store/)、[試用の説明](https://support.codeweavers.com/installing-crossover)

互換性データベースでは、対象OSがMacか、確認されたCrossOverとゲームのバージョンが新しいかを確認する。
同名ゲームでも通常版とリマスター、シングルプレイとオンライン、MODありとなしで条件が変わる。
CodeWeaversのゲームサポートは基本的にMODなしの状態が対象となる。[互換性データベース](https://www.codeweavers.com/compatibility)、[MODのサポート範囲](https://support.codeweavers.com/mods-and-add-ons-with-crossover)

### Porting Kit、Sikarugir、Wine

**Porting Kit**は、ゲーム別の導入設定を利用してWindowsゲームをMacにインストールする無料ツールである。
Windows版Steamを使う導入方式もある。
目当てのゲームの登録内容とApple Silicon向けの説明を確認してから試す。[公式説明](https://www.portingkit.com/app/home.html)、[ダウンロード要件](https://www.portingkit.com/app/download.html)、[Steamを使う導入説明](https://www.portingkit.com/app/app.html)

**Sikarugir**はWineskinの後継で、アプリをWine環境ごと包んで使うツールである。
公式READMEではmacOS 14.6以降、Apple SiliconではRosetta 2を要求し、D3DMetalやDXMTなどを案内している。
同READMEはCrossOverやWhiskyの置き換えではないとも明記しているため、同じ使いやすさを期待せず設定用ツールとして扱う。[公式リポジトリ](https://github.com/Sikarugir-App/Sikarugir)

入手先は上記の公式GitHubからたどる。
開発元は、同名の `sikarugir.com` が無関係なサイトであると明示している。[開発元の注意書き](https://github.com/Sikarugir-App/Sikarugir)

**Wine**そのものを導入し、Steamや描画用の部品を組み合わせる方法もある。
WineはWindows APIを変換する互換層であり、Windows OSのコピーではない。
設定や更新対応の手間を自分で引き受けるため、無料という理由だけで最短手順になるとは限らない。[Wine公式](https://www.winehq.org/)

### Game Porting Toolkit

Appleの**Game Porting Toolkit（GPTK）**には、変更前のWindows実行ファイルをApple Silicon上で評価する環境が含まれる。
公式ページの現行表記はGPTK 4で、目的はMacなどへのゲーム移植である。
一般利用者向けの万能互換モードではなく、環境構築やゲームごとの調整が必要になる。
Apple自身もCrossOverなどを評価環境への入口として案内している。[Apple Developer](https://developer.apple.com/games/game-porting-toolkit/)

Porting KitとAppleのGame Porting Toolkitは別の製品である。
MacでSteamゲームを遊ぶことだけが目的なら、まず完成したランチャーやCrossOverを試す方が作業量は少ない、というのが本調査の判断である。

### 開発停止や新しいランチャーの扱い

| ツール | 一次資料で確認できた状態 | 判断 |
| --- | --- | --- |
| Whisky本家 | 2025年5月11日にリポジトリがアーカイブ。新しいSteamをサポートしないと公式文書に記載 | 新規導入には勧めない。古いSteamへの固定を前提にしない。[本家](https://github.com/Whisky-App/Whisky)、[Steamの問題](https://docs.getwhisky.app/steam.html) |
| Whisky派生版 | 開発を続けるコミュニティフォークは存在 | 本家の保守終了と区別する。今回、その互換性や配布物は未検証。[フォーク](https://github.com/frankea/Whisky) |
| GameHub for Mac | 公開ベータ。Steamアカウント連携、Wineの選択、ゲーム別設定を掲載 | 候補には含めるが、このMacでの実動作と料金を確定できていない。[提供元ページ](https://www.gamemac.com/en) |
| Mythic | 公式リリース説明はアルファ段階。Steam統合は未完成で、Windows版Steamの手動導入を案内 | Epic中心の用途も含むため、Steamだけなら第一候補にしない。[公式リリース](https://getmythic.app/releases) |
| Heroic | Epic、GOG、Amazon中心。2.19.0で動かなくなったSteam導入ボタンを削除 | 他ストアには有用だが、Steamの簡単な代替導入として勧めない。[公式サイト](https://heroicgameslauncher.com/)、[2.19.0](https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/tag/v2.19.0) |
| Merlot | WineとDXMT、Windows版Steamを導入するコミュニティスクリプト。Apple Silicon限定 | 構成を理解して使う候補。商用サポートのある製品と区別する。[実装元](https://github.com/ByMedion/macos-wine-steam) |
| PlayOnMac | 公式ダウンロードは4.4.4を掲載 | このMacと現行Steamでの適合を一次資料で確認できず、優先しない。[公式配布](https://www.playonmac.com/download/) |

## Windowsの仮想環境

M2での基本構成は、仮想化ソフトにWindows 11 Armを入れ、その中でWindows版Steamを使う形である。
x86／x64のゲームはWindows側の変換も利用するため、Windowsが起動した事実だけではゲームの互換性を判断できない。[MicrosoftのMac向け案内](https://support.microsoft.com/en-us/windows/experience/platform-variants/options-for-using-windows-11-with-mac-computers-with-apple-m1-m2-and-m3-chips)

| 製品 | グラフィックなどの制約 | 費用 |
| --- | --- | --- |
| Parallels Desktop | 公式試用ページではDX11対応、DX12非対応。アンチチートなどのVM制約もある | 有料。Proの14日試用。Windowsは別ライセンス。[公式試用](https://www.parallels.com/products/desktop/trial/) |
| VMware Fusion Pro | Apple SiliconではArm64ゲスト。Windows向けDX11の3D加速を提供 | 個人、商用、教育ともFusionは無料。Windowsは別途。[製品仕様](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion)、[無料化の発表](https://blogs.vmware.com/cloud-foundation/2024/11/11/vmware-fusion-and-workstation-are-now-free-for-all-users/) |
| UTM | 4系安定版と5系ベータを区別。5.0.5 Betaで実験的Windows 3D、D3DMetalが利用できる場合のDX12対応を掲載。公式に限定的な互換性と不安定さの注意がある | Web配布版無料。Windowsは別途。[5.0.5 Beta](https://github.com/utmapp/UTM/releases/tag/v5.0.5)、[配布方法](https://docs.getutm.app/installation/macos/) |

ParallelsのStandardは仮想マシンあたり8 GB RAM、4 vCPUまで。
Proを買っても物理メモリ16 GBが増えるわけではないため、ゲームだけのために上位版を買う前に試用で確認する。[公式エディション比較](https://www.parallels.com/jp/products/desktop/buy/)

MicrosoftはParallels上のWindows 11 Proにも別ライセンスを要求している。
Windowsの製品キーはx64とArmで共通だが、既存ライセンスを使い回せるかはそのライセンス条件次第である。[Microsoftのライセンス案内](https://support.microsoft.com/en-us/windows/experience/platform-variants/options-for-using-windows-11-with-mac-computers-with-apple-m1-m2-and-m3-chips)

更新済みのWindows 11 24H2以降のPrismはAVX／AVX2などに対応している。
古い記事の「Arm版WindowsだからAVXを使うゲームはすべて不可」という判断は使えない。
ゲームの必要命令、仮想GPU、ドライバ、アンチチートはそれぞれ確認する必要がある。[Microsoftの互換性説明](https://learn.microsoft.com/en-us/windows/arm/apps-on-arm-program-compat-troubleshooter)

## クラウドで動かす方法

### GeForce NOW

**GeForce NOW**は、NVIDIA側でゲームを動かし、その映像をMacへ送るサービスである。
日本で利用でき、Free、Performance、Ultimateのプランがある。
対象ゲームの所有権は原則別途必要で、契約すれば全ゲームが付属するわけではない。[日本公式FAQ](https://www.nvidia.com/ja-jp/geforce-now/faq/)

最初に確認するのは、ゲーム名だけでなく、その**Steam版が日本で配信対象か**である。
同じタイトルでもストアや地域による違いがあり、Steamの全ライブラリを持ち込めるわけではない。[公式ゲーム一覧](https://www.nvidia.com/ja-jp/geforce-now/games/)

有料プランには月100時間のプレミアムプレイ時間があり、未使用分を最大15時間繰り越せる。
超過後は追加時間を買うか、基本リグで継続する。
2026年4月30日以降、有料会員は超過後もInstall-to-Playを利用できる。[現在の時間制限](https://www.nvidia.com/ja-jp/geforce-now/faq/)

**Install-to-Play**は、メーカーがSteam Cloud Playに参加させた対象ゲームを追加でインストールする仕組みである。
任意のSteamゲームを自由に追加する機能ではない。
有料会員には100 GBのセッション用ストレージがあり、永続ストレージは別契約。
通常のセッション用領域では再インストールが必要になり、Steam Cloud非対応ゲームのセーブ保持にも注意する。[公式のInstall-to-Play説明](https://nvidia.custhelp.com/app/answers/detail/a_id/5675/kw/experience/related/1)

回線の公式目安は720p／60fpsで15 Mbps、1080p／60fpsで25 Mbps、サーバーまでの遅延80 ms未満。
有線または5 GHz Wi-Fiが推奨される。
これらは最低条件であり、格闘ゲームや対戦FPSで満足できる遅延の保証ではないため、無料枠で操作感を確かめる。[システム要件](https://www.nvidia.com/ja-jp/geforce-now/system-reqs/)

日本円の現行価格は今回の公開ページ取得から確定できなかった。
2024年の旧プラン価格を現在価格として転記せず、アプリまたは公式の契約画面で確認する。[料金確認の案内](https://www.nvidia.com/ja-jp/geforce-now/faq/)

### Boosteroid、Shadow、Xbox Cloud Gaming

**Boosteroid**は別のクラウドゲーム候補だが、公式が挙げる提供地域は欧州、北米、ブラジルである。
日本からの利用を一律に不可能とは断定できないものの、日本の近接サーバーや品質を確認できず、先に選ぶ根拠は弱い。[公式地域案内](https://help.boosteroid.com/en/content/where-is-the-service-available)

**Shadow PC**はWindowsのクラウドPCを借りる方式である。
日本はサポート対象国に含まれない。
公式は対象国外からも技術的には契約可能と説明しているが、接続品質を保証しないため、日本からのゲーム用途には勧めにくい。[対象国](https://support.shadow.tech/hc/en-us/articles/33563634214161-Frequently-Asked-Questions-FAQ)、[対象国外利用の説明](https://shadow.tech/gb/faq/)

**Xbox Cloud Gaming**もMacから遊ぶ手段ではあるが、配信するのは対象のXboxゲームである。
Steamで購入済みのライセンスをそのまま持ち込む仕組みではないため、Steamライブラリを遊ぶという今回の目的とは分けて検討する。[Xbox公式](https://www.xbox.com/ja-JP/cloud-gaming)、[所有ゲーム配信の説明](https://news.xbox.com/ja-jp/2024/11/21/stream-your-own-game-xbox-cloud-gaming-beta/)

## 手持ちのWindows PCからMacへ配信

**Steam Remote Play**では、ゲームを実行できるPCとMacでSteamを使い、映像と操作をネットワーク経由でやり取りする。
受信にはSteam Linkアプリも使える。
配信元PCの電源、Steam、ゲームが動いている必要があり、MacだけでWindowsゲームを実行する方式ではない。
友人とローカル協力プレイを共有するRemote Play Togetherとは用途が異なる。[Steam公式](https://store.steampowered.com/remoteplay)

配信元がすでにあるなら、この方式を最初に試す判断は、追加の互換環境やクラウド契約が不要なことによる。
ただし、入力遅延や画質はPCとネットワーク次第なので、競技目的では実際のプレイで確認する。

より配信設定を調整したい場合は、Windows側に**Sunshine**、Mac側に**Moonlight**を入れる方法もある。
NVIDIA GPU専用ではなく、AMDやIntelのGPUにも対応する。
外出先からの接続には、接続方式に応じたネットワーク設定が必要になる。[Moonlight公式](https://moonlight-stream.org/)、[公式設定ガイド](https://github.com/moonlight-stream/moonlight-docs/wiki/Setup-Guide)

**Parsec**もMacからWindows PCを操作でき、個人の非商用ゲーム用途は無料で使える。
クラウドPC自体を貸すサービスではないので、配信元のPCは別途用意する。[料金と用途](https://parsec.app/pricing)、[Macの導入案内](https://support.parsec.app/hc/en-us/articles/32381555792148-Install-Parsec-App-on-macOS)

## OSを替える方法と旧作の例外

**Boot Camp**はApple公式ではIntel MacにWindows 10を入れる手段であり、このM2 Macでは利用できない。[Apple公式](https://support.apple.com/en-ie/102622)

**Fedora Asahi Remix**を導入し、Linux上でSteamとProtonを使う経路は存在する。
Asahiの公式説明では、M1／M2でFEX、Wine、DXVK／vkd3d-proton、muvmを組み合わせてゲームを動かす。
2024年の記事時点で多くのゲームに16 GBのメモリが必要と説明されており、手元の16 GBが十分な余裕を保証するわけではない。
Linuxの導入、ディスク領域の確保、再起動を伴うため、ゲームを数本遊ぶための最初の方法としては勧めない。[Asahi公式のゲーム対応説明](https://asahilinux.org/2024/10/aaa-gaming-on-asahi-linux/)

古いアドベンチャーゲームなどには、**ScummVM**で正規のゲームデータを読み込んで遊べるものもある。
これは対象ゲーム固有の代替エンジンであり、一般のWindowsゲームを実行する方法ではない。
ゲームデータの入手と対応一覧の確認が必要になる。[ScummVMのデータ要件](https://docs.scummvm.org/en/latest/use_scummvm/game_files.html)

## 動作を左右する条件

1. **アンチチート**：CrossOverは低レベルのWindows向けアンチチートを互換層で動かせず、回避もサポートしない。ゲーム開発側の対応が必要になる。オンラインモードだけ動かない場合も含め、ゲーム名とモードを確認する。[CodeWeavers](https://support.codeweavers.com/anti-cheat)
2. **Arm対応とVM対応の違い**：Windows Armでゲームが動くことは、Mac上の仮想Windowsでの動作を保証しない。MicrosoftはArmゲーム対応の進展を報告しているが、仮想環境の制約は別に残る。[Microsoftの進展報告](https://blogs.windows.com/windowsexperience/2025/12/09/windows-pc-gaming-in-2025-handheld-innovation-arm-progress-and-directx-advances/)、[Parallelsの説明](https://www.parallels.com/blogs/windows-11-on-apple-silicon/)
3. **Steam Deckとの違い**：DeckやProtonでの動作報告はLinux向け。macOSにそのまま適用できない。EACやBattlEyeのProton対応にもゲーム開発側の設定が必要。[Steamworks](https://partner.steamgames.com/doc/steamhardware/proton)
4. **描画とCPU命令**：DX11／DX12、AVXなどの条件を満たしても、ランチャーや映像再生で失敗する可能性が残る。互換性は部品名ではなくゲーム全体で評価する。[CrossOverの描画方式](https://support.codeweavers.com/en_US/advanced-settings-in-crossover-mac-26)、[Windows Armの互換性](https://learn.microsoft.com/en-us/windows/arm/apps-on-arm-program-compat-troubleshooter)
5. **Mac版の有無**：後からMac版が提供されている場合は、それを先に確認する。ただし32bitの古いMac版はCatalina以降で動かない。RosettaもWindows APIを提供するものではない。[Appleの32bit対応説明](https://support.apple.com/en-ie/103076)、[Rosettaの説明](https://support.apple.com/ja-jp/102527)

Mac内で重いゲームを試すときは、低画質、720p〜1080p、30fps目標などから始め、負荷の高い場面と長めのプレイで調整するのがよい。
これは試験条件の提案であり、M2でその性能が出るという測定結果ではない。

将来のOS更新については、AppleがRosettaの一般提供をmacOS 27までと案内している。
Rosettaに依存する互換ソフトの長期利用を考える場合は、OS更新前にその製品の対応状況を確認する。[Appleの移行案内](https://support.apple.com/ja-jp/102527)

## 購入前に行う確認

1. ゲーム名、通常版／リマスターなどのエディション、SteamのストアURLを特定する。
2. オンライン対戦、MOD、日本語入力、コントローラーなど、必要な遊び方を決める。
3. GeForce NOWのSteam版対応、CrossOverのMac向け動作情報、Porting Kitの登録を確認する。
4. 体験版や既に所有しているゲームで、タイトル画面だけでなく本編、セーブとロード、音声、必要なオンラインモードを試す。
5. 新規購入する場合はSteamの返金条件を確認する。原則として購入から14日以内かつプレイ時間2時間未満が基準であり、外部ストア購入のキーはSteamで返金できない。[Steam公式返金ポリシー](https://store.steampowered.com/steam_refunds)

今回未確定なのは、対象ゲームでの実動作、回線品質、各有料製品の日本向け最終価格である。
ゲーム名が決まれば、候補を絞り、試用する方式と設定まで具体化できる。

## GitHubのOSS候補を追加調査

同日、GitHubのREADME、ライセンス、公開APIの更新履歴とリリースを確認した。
初回の一覧に含まれていなかったHighballも、無料のローカル環境の有力な試用候補に加える。
以下は配布物の実機検証や安全性監査の結果ではない。

| 候補 | OSSの範囲と更新状況 | Steam用途での評価 |
| --- | --- | --- |
| [Highball](https://github.com/gauthierpiarrette/highball) | アプリはGPL-3.0、互換性データはCC0。確認時はv0.9.32、2026-09-19 UTC公開 | SteamとWineの導入をGUIで進められる。ゲーム別の描画方式と互換性情報があるため、最初に試す候補。ただし2026年8月に公開された新しいベータ |
| [Whiskyのfrankea版](https://github.com/frankea/Whisky) | GPL-3.0。安定アプリ3.7.0は2026-08-30公開。9月にも開発継続 | 停止した本家とは別。標準エンジンはWine 11.0で、DX11系の試用候補。DX12の新エンジンは手動導入のベータ |
| [Merlot](https://github.com/ByMedion/macos-wine-steam) | 導入スクリプトはMIT。確認時の最終コミットは2026-06-25、Wineを11.10 stagingへ更新 | SteamとWine、DXMTの構成が小さく、仕組みを把握しやすい。主にDX10／11系を試す候補。READMEの検証機はM1 MaxとM2 Proで、手元のM2 Airとは異なる |
| [Soju](https://github.com/BCD1210/soju) | GPL-3.0。v1.6.6、2026-09-19 UTC公開 | 複数ストアをまとめる用途。Steam専用のWine 11＋DXMT環境を使う。公式のゲーム動作例はM4 Pro上での結果であり、M2での保証ではない |

Highball本体の要件はApple SiliconとmacOS 14以降。
ただしv0.9.32で追加したGPTK 4の新エンジンはmacOS 27以降向けなので、このMacの26.6.2では対応する別エンジンを使う。[要件と構成](https://github.com/gauthierpiarrette/highball)、[v0.9.32](https://github.com/gauthierpiarrette/highball/releases/tag/v0.9.32)

アプリ本体がOSSでも、D3DMetalはAppleの独自ライセンスの部品である。
Steam本体もOSSではないため、「OSSのランチャー」と「実行環境全体がOSS」は区別する。
Sikarugirは一部コンポーネントのLGPLソースを公開しているが、READMEだけでは製品全体を同じライセンスのOSSと確認できない。[Highballのライセンス説明](https://github.com/gauthierpiarrette/highball#licensing)、[Sikarugirの構成別ライセンス説明](https://github.com/Sikarugir-App/Sikarugir)

NorthLineLauncherは検索結果に残っていたが、調査時のGitHubページと公開APIは404だったため、現在入手できる候補には採用しなかった。

frankea版WhiskyのDX12用ベータには、Steam Storeの黒画面など継続確認中の問題がある。
安定アプリのリリース後にmainへ入った修正もあるため、コミットの存在を配布済みの修正と混同しない。[安定アプリ3.7.0](https://github.com/frankea/Whisky/releases/tag/app-v3.7.0)、[エンジン依存一覧](https://github.com/frankea/Whisky/blob/main/docs/DEPENDENCIES.md)、[ベータの調査Issue](https://github.com/frankea/Whisky/issues/163)
