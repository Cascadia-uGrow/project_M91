-define(PY_PATH, "/home/indicasloth/project_M91/rpi").
-define(HW_CONFIG, "/home/indicasloth/.m91/config/hw.conf").
-define(ENV_CONFIG, "/home/indicasloth/.m91/config/env.conf").
-define(DB_DIR, "/home/indicasloth/.m91/db/").
-define(DB_BACK, "/home/indicasloth/.m91/db/BACKUP").

-record(hw_entry, {type, name, addr}).
-record(hw_state, {pyPid, tab}).

