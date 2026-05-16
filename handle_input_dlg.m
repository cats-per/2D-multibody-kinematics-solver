function [answer, tf] = handle_input_dlg(c)

for i = 1:numel(c.x)
    list_string{i} = "c" + num2str(i);
end

prompt = "Które człony wyświetlić?";

[answer, tf] = listdlg("ListString", list_string, "PromptString", prompt, "Name", "Wybór", "SelectionMode","multiple");
end