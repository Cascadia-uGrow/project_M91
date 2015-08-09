-define(PY_PATH, "/home/ugrow/project_M91/rpi").
-define(HW_CONFIG, "/home/ugrow/.m91/config/hw.conf").
-define(ENV_CONFIG, "/home/ugrow/.m91/config/env.conf").
-define(DB_DIR, "/home/ugrow/.m91/db/").
-define(DB_BACK, "/home/ugrow/.m91/db/BACKUP").

-record(hw_entry, {type, name, port}).
-record(hw_state, {pyPid, tab}).

