#!/usr/bin/env bash

elixir --detached -e "File.write! 'tmp/pids/bot.pid', :os.getpid" -S mix run --no-halt
