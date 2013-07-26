#!/usr/bin/env bats

@test "starts gunicorn process" {
  run pgrep -f ^.*gunicorn.*localshop.*gunicorn_config.py$
  [ $status -eq 0 ]
}

@test "gunicorn is available on port 8080" {
  run nc -z 0.0.0.0 8080
  [ $status -eq 0 ]
}

@test "starts celery process" {
  run pgrep -f ^.*localshop.*manage.py.*celeryd$
  [ $status -eq 0 ]
}
