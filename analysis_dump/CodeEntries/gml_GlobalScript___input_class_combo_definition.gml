function __input_class_combo_definition(arg0, arg1) constructor
{
    static __ensure_verb_is_basic_or_chord = function(arg0)
    {
        if (variable_struct_exists(global.__input_combo_verb_dict, arg0))
        {
            __input_error("Combos only accept basic verbs and chords when defining phases. Combo \"", arg0, "\" cannot be used");
        }
        if (!variable_struct_exists(global.__input_basic_verb_dict, arg0) && !variable_struct_exists(global.__input_chord_verb_dict, arg0))
        {
            __input_error("Verb \"", arg0, "\" not found either as a basic verb or a chord. Please define verbs and chords before combos");
        }
    };
    
    static timeout = function(arg0)
    {
        if (array_length(__phase_array))
        {
            __input_error("Cannot change the timeout for previous phase, no phases have been added");
            exit;
        }
        __phase_array[array_length(__phase_array) - 1].__timeout = arg0;
    };
    
    static press = function(arg0)
    {
        __ensure_verb_is_basic_or_chord(arg0);
        array_push(__phase_array, 
        {
            __type: UnknownEnum.Value_0,
            __timeout: __default_timeout,
            __verb: arg0
        });
        return self;
    };
    
    static release = function(arg0)
    {
        __ensure_verb_is_basic_or_chord(arg0);
        array_push(__phase_array, 
        {
            __type: UnknownEnum.Value_1,
            __timeout: __default_timeout,
            __verb: arg0
        });
        return self;
    };
    
    static press_or_release = function(arg0)
    {
        __ensure_verb_is_basic_or_chord(arg0);
        array_push(__phase_array, 
        {
            __type: UnknownEnum.Value_2,
            __timeout: __default_timeout,
            __verb: arg0
        });
        return self;
    };
    
    static hold = function(arg0)
    {
        __ensure_verb_is_basic_or_chord(arg0);
        array_push(__phase_array, 
        {
            __type: UnknownEnum.Value_3,
            __timeout: __default_timeout,
            __verb: arg0
        });
        return self;
    };
    
    __name = arg0;
    __default_timeout = arg1;
    __phase_array = [];
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2,
    Value_3
}
