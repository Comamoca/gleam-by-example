//// レスポンス生成ヘルパと、エラー -> HTTPステータスの変換。
//// ステータスコードの割り当てはこのモジュールに一元化する。

import error.{type TodoAppError, DbError, TaskNotFound, UnexpectedTaskState, UuidParseError}
import gleam/bytes_tree
import gleam/http/response
import gleam/json.{type Json}
import mist

pub type Response =
  response.Response(mist.ResponseData)

pub fn json(status: Int, data: Json) -> Response {
  response.new(status)
  |> response.set_header("content-type", "application/json")
  |> response.set_body(mist.Bytes(
    bytes_tree.from_string_tree(json.to_string_tree(data)),
  ))
}

pub fn json_error(status: Int, message: String) -> Response {
  json(status, json.object([#("error", json.string(message))]))
}

pub fn no_content() -> Response {
  response.new(204)
  |> response.set_body(mist.Bytes(bytes_tree.new()))
}

pub fn not_found() -> Response {
  json_error(404, "not found")
}

pub fn from_error(e: TodoAppError) -> Response {
  let status = case e {
    TaskNotFound -> 404
    UuidParseError -> 400
    UnexpectedTaskState -> 422
    DbError(_) -> 500
  }
  json_error(status, error.to_string(e))
}
