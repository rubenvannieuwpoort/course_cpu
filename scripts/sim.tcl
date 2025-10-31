# capture environment variables
set project $env(PROJECT)
set module $env(MODULE)

open_project $project

set_property top ${module}_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
update_compile_order -fileset sim_1

launch_simulation
