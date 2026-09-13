//// Task のリポジトリ。
////
//// DB接続のライフサイクル (open/close) と
//// DB行 <-> ドメインモデルの変換をここに閉じ込める。
//// ハンドラはこのモジュールの関数だけを相手にする。

import db/params
import db/sqlight_adapter as adapter
import error.{type TodoAppError, DbError, TaskNotFound}
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import model.{type Task}
import sqlight
import youid/uuid

const path = "todo.sqlite3"

/// 接続を開いて処理を実行し、必ず閉じる。
/// sqlight.Error はここで TodoAppError に畳む。
fn with_db(
  f: fn(sqlight.Connection) -> Result(a, sqlight.Error),
) -> Result(a, TodoAppError) {
  case sqlight.open(path) {
    Ok(db) -> {
      let result = f(db)
      let _ = sqlight.close(db)
      result |> result.map_error(DbError)
    }
    Error(e) -> Error(DbError(e))
  }
}

pub fn all_tasks() -> Result(List(Task), TodoAppError) {
  use rows <- result.try(with_db(adapter.all_task))
  list.try_map(rows, model.from_db)
}

pub fn get_task(id: uuid.Uuid) -> Result(Task, TodoAppError) {
  let p = params.GetTaskParams(id: uuid.to_string(id))
  use row <- result.try(with_db(adapter.get_task(_, p)))
  case row {
    Some(row) -> model.from_db(row)
    None -> Error(TaskNotFound)
  }
}

pub fn create_task(title: String) -> Result(Task, TodoAppError) {
  let task = model.Task(id: uuid.v7(), title: title, state: model.Todo)
  let p =
    params.AddTaskParams(
      id: uuid.to_string(task.id),
      title: task.title,
      state: model.state_to_string(task.state),
    )
  use _ <- result.try(with_db(adapter.add_task(_, p)))
  Ok(task)
}

pub fn update_task_state(
  id: uuid.Uuid,
  state: model.State,
) -> Result(Task, TodoAppError) {
  let p =
    params.UpdateTaskStateParams(
      state: model.state_to_string(state),
      id: uuid.to_string(id),
    )
  use _ <- result.try(with_db(adapter.update_task_state(_, p)))
  get_task(id)
}

pub fn delete_task(id: uuid.Uuid) -> Result(Nil, TodoAppError) {
  // 存在しなければ TaskNotFound (404) を返す
  use _ <- result.try(get_task(id))
  let p = params.RemoveTaskParams(id: uuid.to_string(id))
  with_db(adapter.remove_task(_, p))
}
