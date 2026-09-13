//// Task の JSON コーデック。
//// JSON は HTTP の境界 (web層) だけで扱い、model には持ち込まない。

import gleam/dynamic/decode
import gleam/json.{type Json}
import model
import youid/uuid

pub fn encode(task: model.Task) -> Json {
  json.object([
    #("id", json.string(uuid.to_string(task.id))),
    #("title", json.string(task.title)),
    #("state", json.string(model.state_to_string(task.state))),
  ])
}

/// POST /api/tasks のボディ: {"title": "..."}
pub fn title_decoder() -> decode.Decoder(String) {
  use title <- decode.field("title", decode.string)
  decode.success(title)
}

/// PATCH /api/tasks/:id のボディ: {"state": "todo" | "progress" | "done"}
pub fn state_decoder() -> decode.Decoder(model.State) {
  use state <- decode.field("state", decode.string)
  case model.state_from_string(state) {
    Ok(state) -> decode.success(state)
    Error(_) ->
      decode.failure(model.Todo, "state must be one of: todo, progress, done")
  }
}
