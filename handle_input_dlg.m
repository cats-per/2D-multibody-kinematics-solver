function [answer1, tf1, answer2, tf2] = handle_input_dlg(c)

for i = 1:numel(c.x)
    list_string1{i} = "c" + num2str(i);
end

list_string2 = {"PDF";
                "PNG"};

prompt1 = "Które człony wyświetlić?";
prompt2 = "Jaki format pliku?";

[answer1, tf1] = listdlg("ListString", list_string1, "PromptString", prompt1, "Name", "Wybór", "SelectionMode","multiple");
[answer2, tf2] = listdlg("ListString", list_string2, "PromptString", prompt2, "Name", "Wybór", "SelectionMode", "single");
end