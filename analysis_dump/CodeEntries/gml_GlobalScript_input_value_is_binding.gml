function input_value_is_binding(arg0)
{
    return is_struct(arg0) && instanceof(arg0) == "__input_class_binding";
}
