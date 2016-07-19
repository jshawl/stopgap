drop table if exists projects;
drop table if exists resources;
drop table if exists entities;

CREATE TABLE projects (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  nationality VARCHAR(255),
  birth_year INTEGER
);

CREATE TABLE resources (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255),
  project_id INTEGER
);

CREATE TABLE entities (
  id SERIAL PRIMARY KEY,
  resource_id INTEGER,
  content JSON
);

