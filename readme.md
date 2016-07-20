# Fake Rest API

## Local Setup

```
$ bundle install
$ createdb fake_rest
$ psql -d fake_rest < config/schema.sql
$ rackup
```