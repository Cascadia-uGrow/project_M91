-define(PY_PATH, "/home/indicasloth/CMGS/project_M91/rpi").
-define(HW_CONFIG, "/home/indicasloth/.m91/config/hw.conf").
-define(DB_DIR, "/home/indicasloth/.m91/db/").
-define(DB_BACK, "/home/indicasloth/.m91/db/BACKUP").

-record(hw_entry, {type, name, port}).
-record(hw_state, {pyPid, tab}).

