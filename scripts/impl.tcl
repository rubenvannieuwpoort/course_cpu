# capture environment variables
set project $env(PROJECT)

# open project, launch impl run, and wait for it to finish
open_project $project

# reset when the previous run failed
set run_status [get_property STATUS [get_runs synth_1]]
if { $run_status ne "NotStarted" && $run_status ne "Running" } {
    reset_run synth_1
}

set run_status [get_property STATUS [get_runs impl_1]]
if { $run_status ne "NotStarted" && $run_status ne "Running" } {
    reset_run impl_1
}

launch_runs impl_1 -jobs 16
wait_on_run impl_1
