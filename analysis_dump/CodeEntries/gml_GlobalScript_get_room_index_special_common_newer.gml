function get_room_index_special_common_newer()
{
    var room_array = array_create(0);
    array_push(room_array, rm_s_01);
    array_push(room_array, rm_s_02);
    array_push(room_array, rm_s_03);
    array_push(room_array, rm_s_04);
    array_push(room_array, rm_s_05);
    array_push(room_array, rm_s_06);
    array_push(room_array, rm_s_07);
    array_push(room_array, rm_s_08);
    array_push(room_array, rm_s_09);
    array_push(room_array, rm_s_10);
    array_push(room_array, rm_s_23);
    array_push(room_array, rm_s_24);
    array_push(room_array, rm_s_30);
    var result = room_array[irandom(array_length(room_array) - 1)];
    return result;
}
