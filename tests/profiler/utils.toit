// Copyright (C) 2020 Toitware ApS. All rights reserved.

import host.pipe
import reader show BufferedReader

/**
Runs the given test with $args containing `toitc` as first argument, and
  the input as second.

Returns the lines of the output.
Throws if the program didn't terminate with exit code 0.
*/
run args -> List:
  toitc := args[0]
  profiled_path := args[1]

  pipes := pipe.fork
      true    // use_path
      pipe.PIPE_INHERITED  // stdin
      pipe.PIPE_INHERITED  // stdout
      pipe.PIPE_CREATED    // stderr
      toitc
      [ toitc, profiled_path ]

  stderr := pipes[2]
  pid := pipes[3]

  reader := BufferedReader stderr
  reader.buffer_all
  output := reader.read_string (reader.buffered)

  exit_value := pipe.wait_for pid
  exit_code := pipe.exit_code exit_value

  if exit_code != 0: throw "Program didn't exit with 0."
  lines := output.split "\n"
  return lines