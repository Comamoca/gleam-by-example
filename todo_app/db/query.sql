-- name: AllTask :many
SELECT id, title, state
FROM tasks
ORDER BY id;

-- name: GetTask :one
SELECT id, title, state
FROM tasks
WHERE id = sqlode.arg(id);

-- name: AddTask :exec
INSERT INTO tasks (id, title, state)
VALUES (sqlode.arg(id), sqlode.arg(title), sqlode.arg(state));

-- name: RemoveTask :exec
DELETE FROM tasks
WHERE id = sqlode.arg(id);

-- name: UpdateTaskState :exec
UPDATE tasks
SET state = sqlode.arg(state)
WHERE id = sqlode.arg(id);
