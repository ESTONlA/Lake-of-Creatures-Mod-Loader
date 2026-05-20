function spawn_overworld_rooms_1(arg0, arg1)
{
    var start_block = instance_create_depth(arg0, arg1, 0, obj_world_gen_block);
    start_block.spawned_from_generating = false;
    start_block.room_index = rm_overworld_1;
    start_block.layout_index = 2;
    var block = instance_create_depth(arg0 + 16, arg1, 0, obj_world_gen_block);
    block.spawned_from_generating = false;
    block.room_index = rm_overworld_2;
    block.layout_index = 1;
    return start_block;
}
