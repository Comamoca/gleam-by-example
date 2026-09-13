//// sqlight_adapter が生成した関数を一通り叩くデモ。
////
////   gleam run -m tmp
////
//// atlas のマイグレーションが手元に無くても動くよう、
//// 起動時に CREATE TABLE IF NOT EXISTS を実行している。

import db/models.{type Task}
import db/params
import db/sqlight_adapter as db
import gleam/io
import gleam/list
import gleam/option.{Some}
import sqlight
import youid/uuid

// db/schema.sql と同じ DDL + IF NOT EXISTS
const schema = "
CREATE TABLE IF NOT EXISTS tasks (
  id    UUID PRIMARY KEY,
  title TEXT NOT NULL,
  state TEXT NOT NULL CHECK (state IN ('todo', 'progress', 'done'))
)
"

pub fn main() {
  let assert Ok(conn) = sqlight.open("todo.sqlite3")

  // --- マイグレーション ---
  let assert Ok(_) = sqlight.exec(schema, on: conn)

  // --- AddTask :exec ---
  let milk = new_id()
  let blog = new_id()
  let todo_app = new_id()

  let assert Ok(_) =
    db.add_task(conn, params.AddTaskParams(milk, "牛乳を買う", "todo"))
  let assert Ok(_) =
    db.add_task(conn, params.AddTaskParams(blog, "ブログを書く", "todo"))
  let assert Ok(_) =
    db.add_task(conn, params.AddTaskParams(todo_app, "todo app を作る", "progress"))

  // --- AllTask :many ---
  io.println("## 3件追加した直後")
  dump(conn)

  // --- UpdateTaskState :exec ---
  let assert Ok(_) =
    db.update_task_state(conn, params.UpdateTaskStateParams("done", milk))

  // --- GetTask :one ---
  io.println("\n## 牛乳を done に更新して取得")
  let assert Ok(Some(task)) = db.get_task(conn, params.GetTaskParams(milk))
  show(task)

  // --- RemoveTask :exec ---
  let assert Ok(_) = db.remove_task(conn, params.RemoveTaskParams(blog))

  io.println("\n## ブログを削除した後")
  dump(conn)
}

fn new_id() {
  uuid.v7()
  |> uuid.to_string
}

fn dump(conn: sqlight.Connection) {
  let assert Ok(tasks) = db.all_task(conn)
  tasks
  |> list.each(show)
}

fn show(task: Task) {
  io.println(task.id <> "  [" <> task.state <> "] " <> task.title)
}
