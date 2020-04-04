f = uifigure;
% tg = uitabgroup(f,'Position',[10 10 600 500]);
% tab1 = uitab(tg,'Title','Settings');
% tab2 = uitab(tg,'Title','Map');
% tab3 = uitab(tg,'Title','Flow Field');
% bg = uibuttongroup(tab1,'Position',[0 365 130 135]);
              
% Create three radio buttons in the button group.
% r1 = uitogglebutton(bg,'Position',[11 40 100 25],'Text','No Flow');
% r2 = uitogglebutton(bg,'Position',[11 75 100 25],'Text','Radnom Flow');
r1 = uicontrol('Style','togglebutton',...
               'String','No Flow',...
               'Callback',@togglebutton1_Callback);
r2 = uicontrol('Style','togglebutton',...
               'String','Random Flow',...
               'Callback',@togglebutton2_Callback);

% uicontrol('Style','togglebutton','Callback',@togglebutton1_Callback);
% uicontrol('Style','togglebutton','Callback',@togglebutton2_Callback);
              
function togglebutton1_Callback(hObject, eventdata)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display('Goodbye');
close(gcf);
end
function togglebutton2_Callback(hObject, eventdata)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display('Goodbye');
close(gcf);
end