function log_remove_lines()
{
    var filename = "log.txt";
    var row_limit = 30;
    if (file_exists(filename))
    {
        var file = file_text_open_read(filename);
        var lines = [];
        while (!file_text_eof(file))
        {
            array_push(lines, file_text_readln(file));
        }
        file_text_close(file);
        if (array_length(lines) > row_limit)
        {
            var extra_rows = array_length(lines) - row_limit;
            array_delete(lines, 0, extra_rows);
            var write_file = file_text_open_write(filename);
            for (var i = 0; i < array_length(lines); i++)
            {
                file_text_write_string(write_file, lines[i]);
                if (i < (array_length(lines) - 1))
                {
                    file_text_write_string(write_file, "\n");
                }
            }
            file_text_close(write_file);
        }
    }
}
