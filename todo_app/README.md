# todo_app

[![Package Version](https://img.shields.io/hexpm/v/todo_app)](https://hex.pm/packages/todo_app)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/todo_app/)

```sh
gleam add todo_app@1
```
```gleam
import todo_app

pub fn main() -> Nil {
  // TODO: An example of the project in use
}
```

Further documentation can be found at <https://hexdocs.pm/todo_app>.

## Development

> [!NOTE]
> 最初のビルドは SQLite の NIF(sqlight/esqlite)を含むため数分かかります。
> 中断するとキャッシュが残らず再コンパイルになるので、完了まで待ってください。

```sh
just setup   # 初回セットアップ(依存取得 + ビルド)
gleam run   # Run the project
gleam test  # Run the tests
```

### SQL ワークフロー

```sh
just codegen      # db/schema.sql + db/query.sql から Gleam コード生成 (sqlode)
just migrate      # db/schema.sql を DB に適用 (atlas)
just migrate-dry  # 差分だけ確認
```
