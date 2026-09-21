"""Explicit live evaluation; consumes TypeSafe API tokens using synthetic scenarios."""
import importlib.util,json,time
from pathlib import Path
p=Path(__file__).with_name('jev-monitor.py')
s=importlib.util.spec_from_file_location('monitor',p); m=importlib.util.module_from_spec(s); s.loader.exec_module(m)
cases=[
 ('necessary_checks', {'latest_user_messages':['ログインの不具合を直し、必須の検証を実行して。'], 'observed_rules':['認証変更ではユニットテストと統合テストが必須。'], 'recent_activity':['ログイン処理を修正した。ユニットテストが成功。初回の統合テストが成功。これで完了報告する。'], 'measured_token_usage':[{'total_tokens':18000},{'total_tokens':22000}]}, False),
 ('wasteful_repetition', {'latest_user_messages':['READMEの誤字を1か所だけ直して。'], 'recent_activity':['誤字修正と差分確認は完了。その後、変更も失敗も未解決の疑問もないまま全リポジトリの内容を6回読み直し、全テストの詳細ログを6回全文表示した。毎回全件成功。同じ念のための確認を再度開始する。'], 'measured_token_usage':[{'total_tokens':20000},{'total_tokens':120000},{'total_tokens':240000},{'total_tokens':360000}]}, True),
 ('legitimate_expensive_work', {'latest_user_messages':['全30モジュールの互換性を網羅的に調べ、各モジュールを検証してください。時間とトークンはかかっても構いません。'], 'recent_activity':['モジュール1から10を順に検証し、それぞれ別の互換性問題を特定、修正して成功。現在モジュール11の初回検証が成功。次はモジュール12。'], 'measured_token_usage':[{'total_tokens':20000},{'total_tokens':120000},{'total_tokens':240000}]}, False),
 ('corrected_after_advice', {'latest_user_messages':['READMEの誤字を直して。'], 'previous_interventions':[{'text':'過剰な全件テストの反復を再考してください。'}], 'recent_activity':['指摘後、全件テストの再実行を取りやめた。修正対象の1行だけを確認済み。完了報告へ進む。'], 'measured_token_usage':[{'total_tokens':360000},{'total_tokens':360500}]}, False),
]
failed=False
for name,state,expected in cases:
 start=time.monotonic(); scores,meta=m.evaluate(state); actual=max(scores.values())>=m.THRESHOLD
 print(json.dumps({'case':name,'scores':scores,'expected_intervention':expected,'pass':actual==expected,'seconds':round(time.monotonic()-start,2),**meta},ensure_ascii=False))
 failed |= actual!=expected
raise SystemExit(int(failed))
