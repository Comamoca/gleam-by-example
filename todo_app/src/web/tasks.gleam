//// /api/tasks のハンドラ。
//// 「リクエストの解釈 -> リポジトリ -> レスポンス」の薄いオーケストレーションに
//// 保つのがきれいに書くコツ。ロジックは model / task_repo に追い出す。

import error.{type TodoAppError, UuidParseError}
import gleam/bit_array
import gleam/dynamic/decode
import gleam/http/request.{type Request}
import gleam/json
import gleam/result
import mist.{type Connection}
import task_repo
import web/respond.{type Response}
import web/task_json
import youid/uuid.{type Uuid}

type BodyError {
  BodyError
}

/// ボディを読み、Dynamic として返す。失敗はすべて BodyError に畳む。
fn read_json(req: Request(Connection)) -> Result(decode.Dynamic, BodyError) {
  use req <- result.try(
    mist.read_body(req, 1_000_000) |> result.replace_error(BodyError),
  )
  use body <- result.try(
    bit_array.to_string(req.body) |> result.replace_error(BodyError),
  )
  json.parse(body, decode.dynamic) |> result.replace_error(BodyError)
}

/// パスセグメントの文字列を Uuid にパースする。
fn parse_id(raw: String) -> Result(Uuid, TodoAppError) {
  uuid.from_string(raw) |> result.replace_error(UuidParseError)
}

// GET /api/tasks
pub fn index() -> Response {
  case task_repo.all_tasks() {
    Ok(tasks) -> respond.json(200, json.array(tasks, task_json.encode))
    Error(e) -> respond.from_error(e)
  }
}

// POST /api/tasks  {"title": "..."}
pub fn create(req: Request(Connection)) -> Response {
  case read_json(req) {
    Error(_) -> respond.json_error(400, "invalid request body")
    Ok(body) ->
      case decode.run(body, task_json.title_decoder()) {
        Error(_) -> respond.json_error(400, "invalid request body")
        Ok(title) ->
          case task_repo.create_task(title) {
            Ok(task) -> respond.json(201, task_json.encode(task))
            Error(e) -> respond.from_error(e)
          }
      }
  }
}

// GET /api/tasks/:id
pub fn show(raw_id: String) -> Response {
  case parse_id(raw_id) {
    Error(e) -> respond.from_error(e)
    Ok(id) ->
      case task_repo.get_task(id) {
        Ok(task) -> respond.json(200, task_json.encode(task))
        Error(e) -> respond.from_error(e)
      }
  }
}

// PATCH /api/tasks/:id  {"state": "..."}
pub fn update(raw_id: String, req: Request(Connection)) -> Response {
  case parse_id(raw_id) {
    Error(e) -> respond.from_error(e)
    Ok(id) ->
      case read_json(req) {
        Error(_) -> respond.json_error(400, "invalid request body")
        Ok(body) ->
          case decode.run(body, task_json.state_decoder()) {
            Error(_) ->
              respond.json_error(
                422,
                "state must be one of: todo, progress, done",
              )
            Ok(state) ->
              case task_repo.update_task_state(id, state) {
                Ok(task) -> respond.json(200, task_json.encode(task))
                Error(e) -> respond.from_error(e)
              }
          }
      }
  }
}

// DELETE /api/tasks/:id
pub fn destroy(raw_id: String) -> Response {
  case parse_id(raw_id) {
    Error(e) -> respond.from_error(e)
    Ok(id) ->
      case task_repo.delete_task(id) {
        Ok(_) -> respond.no_content()
        Error(e) -> respond.from_error(e)
      }
  }
}
