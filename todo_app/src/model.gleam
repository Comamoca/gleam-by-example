import db/models
import error.{type TodoAppError, UnexpectedTaskState, UuidParseError}
import gleam/result
import youid/uuid.{type Uuid}

pub type State {
  Todo
  Progress
  Done
}

pub type Task {
  Task(id: Uuid, title: String, state: State)
}

pub fn state_to_string(state: State) -> String {
  case state {
    Todo -> "todo"
    Progress -> "progress"
    Done -> "done"
  }
}

pub fn state_from_string(state: String) -> Result(State, TodoAppError) {
  case state {
    "todo" -> Ok(Todo)
    "progress" -> Ok(Progress)
    "done" -> Ok(Done)
    _ -> Error(UnexpectedTaskState)
  }
}

pub fn to_db(task: Task) -> models.Task {
  models.Task(
    id: uuid.to_string(task.id),
    title: task.title,
    state: state_to_string(task.state),
  )
}

pub fn from_db(task: models.Task) -> Result(Task, TodoAppError) {
  use id <- result.try(
    task.id |> uuid.from_string |> result.replace_error(UuidParseError),
  )
  use state <- result.try(state_from_string(task.state))
  Ok(Task(id: id, title: task.title, state: state))
}
