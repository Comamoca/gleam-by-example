//// エントリポイント。サーバの起動だけを行う。

import gleam/erlang/process
import mist
import web/router

pub fn main() {
  // NOTE: コンテナ内には IPv6 がないため with_ipv6 は使わない。
  // localhost (127.0.0.1) のみにバインドし、VS Code のポート転送経由でアクセスする。
  let assert Ok(_) =
    router.handle
    |> mist.new
    |> mist.bind("localhost")
    |> mist.port(3000)
    |> mist.start

  process.sleep_forever()
}
