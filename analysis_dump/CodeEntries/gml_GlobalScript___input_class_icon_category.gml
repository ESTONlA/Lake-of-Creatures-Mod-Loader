function __input_class_icon_category(arg0) constructor
{
    static add = function(arg0, arg1)
    {
        variable_struct_set(__dictionary, arg0, arg1);
        return self;
    };
    
    __name = arg0;
    __dictionary = {};
}
