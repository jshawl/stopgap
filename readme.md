# Stopgap

A fake REST API that persists data for up to 24 hours.

## Local Setup

```
$ bundle install
$ createdb fake_rest
$ psql -d fake_rest < config/schema.sql
$ rackup
```