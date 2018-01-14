BEGIN {
  section = "none"
  action = "config"
  if (system("which nproc > /dev/null") == 0) {
	  "nproc --all" | getline procs
	  procs = procs
  } else {
	  procs = 1
  }
}

END {
  for (ext in filter) {
    exts[ext_count++] = "-name \"*." ext "\""
  }
  for (i = 0; i < length(ignore); i++) {
    opts[opt_count++] = "!"
    opts[opt_count++] = "-name \"" ignore[i] "\""
  }
  if (phase == "render") {
    opts[opt_count++] = exts[0]
    for (i = 1; i < length(exts); i++) {
      opts[opt_count++] = "-o"
      opts[opt_count++] = exts[i]
    }
  } else if (phase == "copy") {
    for (i = 0; i < length(exts); i++) {
      opts[opt_count++] = "!"
      opts[opt_count++] = exts[i]
    }
  }
  for (i = 0; i < length(opts); i++) {
    optpart = optpart " " opts[i]
  }
  printf "find \"%s\" -type f -cnewer \"%s/.zod/state\" \\( %s \\) -print0 | xargs -0 -P %s -I {} zod-%s \"%s\" \"%s\" \"%s\" {} \\;",
	  proj, proj, optpart, procs, phase, zod_lib, proj, target
}
