import sqlight

pub type TodoAppError {
  TaskNotFound
  UuidParseError
  UnexpectedTaskState
  DbError(sqlight.Error)
}

pub fn to_string(error: TodoAppError) -> String {
  case error {
    TaskNotFound -> "task not found"
    UuidParseError -> "invalid task id"
    UnexpectedTaskState -> "unexpected task state"
    DbError(_) -> "database error"
  }
}
