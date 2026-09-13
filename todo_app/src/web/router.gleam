//// ルーティング。
//// method x path_segments のパターンマッチがそのままルートテーブルになる。

import gleam/bytes_tree
import gleam/http.{Delete, Get, Patch, Post}
import gleam/http/request.{type Request}
import gleam/http/response
import mist.{type Connection}
import web/respond.{type Response}
import web/tasks

pub fn handle(req: Request(Connection)) -> Response {
  case req.method, request.path_segments(req) {
    Get, [] -> index()
    // ルートテーブル
    Get, ["api", "tasks"] -> tasks.index()
    Post, ["api", "tasks"] -> tasks.create(req)
    Get, ["api", "tasks", id] -> tasks.show(id)
    Patch, ["api", "tasks", id] -> tasks.update(id, req)
    Delete, ["api", "tasks", id] -> tasks.destroy(id)

    _, _ -> respond.not_found()
  }
}

pub fn index() -> Response {
  response.new(200)
  |> response.set_header("content-type", "text/html")
  |> response.set_body(mist.Bytes(bytes_tree.from_string("<h1>Hello</h1>")))
}
