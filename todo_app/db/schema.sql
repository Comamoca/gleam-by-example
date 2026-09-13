CREATE TABLE tasks (
  id    UUID PRIMARY KEY,
  title TEXT NOT NULL,
  state TEXT NOT NULL CHECK (state IN ('todo', 'progress', 'done'))
);
