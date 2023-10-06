CREATE TABLE IF NOT EXISTS Task
(
    id SERIAL NOT NULL PRIMARY KEY,
    title VARCHAR(24) NOT NULL,
    description VARCHAR(256),
    status VARCHAR(16)
);