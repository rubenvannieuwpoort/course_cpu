# capture environment variables
set project_name $env(PROJECT_NAME)
set part $env(PART)
set top_level_module $env(TOP_LEVEL_MODULE)
set design_files $env(DESIGN_FILES)
set sim_files $env(SIM_FILES)
set constrains_file $env(CONSTRAINTS_FILE)


# create project
create_project -f $project_name ./build -part "$part"

# add design files
add_files -norecurse $design_files

# add sim files
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse $sim_files
update_compile_order -fileset sim_1

# add constraints file
add_files -fileset constrs_1 -norecurse $constrains_file

# set top level module
set_property top $top_level_module [current_fileset]

# update compile order
update_compile_order -fileset sources_1
