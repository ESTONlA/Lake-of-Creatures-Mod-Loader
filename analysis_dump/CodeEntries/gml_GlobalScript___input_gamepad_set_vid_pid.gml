function __input_gamepad_set_vid_pid()
{
    var _result = __input_gamepad_guid_parse(guid, true, false);
    vendor = _result.vendor;
    product = _result.product;
    xinput = index < 4;
}
