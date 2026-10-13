# test — Git/GitHub テスト基盤

`Daiki-Yoshida/test` を、Git/GitHub・開発ルーチンの継続的な実験に使うための Docker-first テストプロジェクト。

## 構成

- **Management Root Repository**: このリポジトリ（baseline: `master`、selector: `main`）。プロジェクト調整・`documents/`・公開コマンドを所有。
- **Component Repository**: `tests/<selector>/` 配下に配置する独立 Git 履歴（`dotnet-test` / `script-test` / `documents-test`）。

## ドキュメント

プロジェクトの正規知識は [`documents/INDEX.md`](documents/INDEX.md) を起点にルーティングします。再利用エンジニアリング指針は `documents/artifacts/`（managed pack・インストール済みコピーは編集禁止）。

## 公開コマンド

```bash
./scripts/project.sh help      # 操作一覧
./scripts/project.sh status    # 状態診断
./scripts/project.sh bootstrap # 依存確認・管理ランタイム構築
./scripts/project.sh verify    # 標準の最終検証
```

ホスト依存は Git・Docker/Compose・シェルのみ。言語ランタイムは管理コンテナ内で実行します。

## 境界

- GitHub の書込先は `Daiki-Yoshida/test` のみ
- baseline `master` への直接変更はしない（統合は承認済みの PR 経由）
- ローカルの読み書きは Project Root 内のみ
