# beginners_example

入門Gleamのサンプルリポジトリです。

## Quick start

このリポジトリではDevcontainerをサポートしています。

まずこのリポジトリをcloneします。
次にDevcontainerをセットアップします。VSCodeの方はRemote Containerという拡張機能をインストールして`Open Folder in Container`を選択して下さい。


CLIを使っている方は[Devcontainer CLI](https://github.com/devcontainers/cli)が必要です。任意のパッケージマネージャーで[@devcontainers/cli](https://www.npmjs.com/package/@devcontainers/cli)をインストールして下さい。
@devcontainers/cliを使っている方は以下のコマンドを実行してください。

```sh
# コンテナのビルド
devcontainer build --workspace-folder .

# 任意のコマンドを実行(この例ではgleam runを実行)
devcontainer exec --workspace-folder . gleam run
```
