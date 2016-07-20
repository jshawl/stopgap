drop table if exists calls;
drop table if exists projects;
drop table if exists resources;
drop table if exists entities;

CREATE TABLE calls (
  id SERIAL PRIMARY KEY,
  method VARCHAR(255),
  ts TIMESTAMP DEFAULT NOW()
);

CREATE TABLE projects (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  ts TIMESTAMP DEFAULT NOW(),
  sha VARCHAR(10)
);

CREATE TABLE resources (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255),
  project_id INTEGER,
  entity_id INTEGER
);

CREATE TABLE entities (
  id SERIAL PRIMARY KEY,
  resource_id INTEGER,
  content JSON
);

