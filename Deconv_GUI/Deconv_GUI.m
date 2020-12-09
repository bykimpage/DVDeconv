function varargout = Deconv_GUI(varargin)
% DECONV_GUI MATLAB code for Deconv_GUI.fig
%      DECONV_GUI, by itself, creates a new DECONV_GUI or raises the existing
%      singleton*. 
%
%      H = DECONV_GUI returns the handle to a new DECONV_GUI or the handle to
%      the existing singleton*.
%
%      DECONV_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DECONV_GUI.M with the given input arguments.
%
%      DECONV_GUI('Property','Value',...) creates a new DECONV_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Deconv_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Deconv_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Deconv_GUI

% Last Modified by GUIDE v2.5 01-Aug-2018 00:16:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Deconv_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @Deconv_GUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Deconv_GUI is made visible.
function Deconv_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Deconv_GUI (see VARARGIN)
%===================================================================================================================
% --- My Startup Code --------------------------------------------------
% Clear old stuff from console.
clc;
global BY
global algorithm
global Deconv
global Every_save_check
global file_type

contents = cellstr(get(handles.popupmenu2,'String'));
algorithm = contents{get(handles.popupmenu2, 'Value')};
Every_save_check = false;
file_type = 1; % mat

set(handles.Observe_image, 'Visible', 'on');grid off;
set(handles.Result_image, 'Visible', 'on');grid off;
set(handles.img_path, 'String','Select image sequence folder (.tif or .mat)');
set(handles.PSF_path, 'String','Select PSF sequence folder (.tif or .mat)');
set(handles.text3,'visible','off');
set(handles.Cur_edit,'visible','off');

% Choose default command line output for Deconv_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Deconv_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Deconv_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in XY_radio.
function XY_radio_Callback(hObject, eventdata, handles)
% hObject    handle to XY_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'Deconv')
    DeconvResult = handles.Deconv;
    nz = size(DeconvResult,3);
    current = floor(nz/2);
    set(handles.slider7, 'Enable', 'on');
    handles.currentDeconv = DeconvResult;
    set(handles.text10, 'String', 'z');  
    showDeconv(hObject, handles, DeconvResult, current, nz);
    guidata(hObject, handles);
end
if isfield(handles,'BY')
    BYResult = handles.BY;
    nz = size(BYResult,3);
    current = floor(nz/2);
    set(handles.slider6, 'Enable', 'on');
    handles.currentBYResult = BYResult;
    set(handles.text9, 'String', 'z');  
    showBY(hObject, handles, BYResult, current, nz);
    guidata(hObject, handles);
end
% Hint: get(hObject,'Value') returns toggle state of XY_radio


% --- Executes on button press in YZ_radio.
function YZ_radio_Callback(hObject, eventdata, handles)
% hObject    handle to YZ_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'Deconv')
    DeconvResult = permute(handles.Deconv,[3 2 1]);
    nz = size(DeconvResult,3);
    current = floor(nz/2);
    set(handles.slider7, 'Enable', 'on');
    handles.currentDeconv = DeconvResult;
    set(handles.text10, 'String', 'y');  
    showDeconv(hObject, handles, DeconvResult, current, nz);
    guidata(hObject, handles);
end
if isfield(handles,'BY')
    BYResult = permute(handles.BY,[3 2 1]);
    nz = size(BYResult,3);
    current = floor(nz/2);
    set(handles.slider6, 'Enable', 'on');
    handles.currentBYResult = BYResult;
    set(handles.text9, 'String', 'y');  
    showBY(hObject, handles, BYResult, current, nz);
    guidata(hObject, handles);
end
% Hint: get(hObject,'Value') returns toggle state of YZ_radio


% --- Executes on button press in XZ_radio.
function XZ_radio_Callback(hObject, eventdata, handles)
% hObject    handle to XZ_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'Deconv')
    DeconvResult = permute(handles.Deconv,[2 3 1]);
    nz = size(DeconvResult,3);
    current = floor(nz/2);
    set(handles.slider7, 'Enable', 'on');
    handles.currentDeconv = DeconvResult;
    set(handles.text10, 'String', 'x');  
    showDeconv(hObject, handles, DeconvResult, current, nz);
    guidata(hObject, handles);
end
if isfield(handles,'BY')
    BYResult = permute(handles.BY,[2 3 1]);
    nz = size(BYResult,3);
    current = floor(nz/2);
    set(handles.slider6, 'Enable', 'on');
    handles.currentBYResult = BYResult;
    set(handles.text9, 'String', 'x');  
    showBY(hObject, handles, BYResult, current, nz);
    guidata(hObject, handles);
end
% Hint: get(hObject,'Value') returns toggle state of XZ_radio

function showDeconv(hObject, handles, DeconvResult, current, nz)

set(handles.slider7, 'Min', 1);
set(handles.slider7, 'Max', nz);
set(handles.slider7, 'Value', current);
set(handles.slider7, 'SliderStep', [1/nz,10/nz]);

set(handles.Slice_txt2, 'String', [num2str(current) '/' num2str(nz)]);

axes(handles.Result_image);
imshow(DeconvResult(:,:,current),[]);
drawnow;
guidata(hObject, handles);

% --- Executes on button press in Save_button.
function Save_button_Callback(hObject, eventdata, handles)
% hObject    handle to Save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Every_save_check
global file_type
global Deconv
if (file_type == 1) % mat
    save DeconvResult Deconv
    str2 = get( handles.Result_list, 'String' );
    str2 = cat( 1, {'- DeconvResult.mat File Saved.'}, str2 );
    set(handles.Result_list, 'String',str2);
    drawnow;
elseif  (file_type == 0) % tif
    [~,~,gz] = size(Deconv);
    for num=1:gz
    tmp_f = double(Deconv(:,:,num));
    minD = min(tmp_f(:));
    maxD = max(tmp_f(:));
    mapped_image = (double(tmp_f) - minD) ./ (maxD - minD);
    imwrite(mapped_image, 'DeconvResult.tiff', 'WriteMode', 'append');
    end
    str2 = get( handles.Result_list, 'String' );
    str2 = cat( 1, {'- DeconvResult.tiff File Saved.'}, str2 );
    set(handles.Result_list, 'String',str2);
    drawnow;
end




% --- Executes on button press in tif_radio.
function tif_radio_Callback(hObject, eventdata, handles)
% hObject    handle to tif_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file_type
file_type=0;
% Hint: get(hObject,'Value') returns toggle state of tif_radio


% --- Executes on button press in mat_button.
function mat_button_Callback(hObject, eventdata, handles)
% hObject    handle to mat_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file_type
file_type=1;
% Hint: get(hObject,'Value') returns toggle state of mat_button


% --- Executes on button press in Every_save.
function Every_save_Callback(hObject, eventdata, handles)
% hObject    handle to Every_save (see GCBO)
global Every_save_check
Every_save_check = true;
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of Every_save


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global algorithm
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
contents = cellstr(get(handles.popupmenu2,'String'));
algorithm = contents{get(handles.popupmenu2, 'Value')};
if strcmp(algorithm, 'Depth variant OSL Algorithm');
    set(handles.text3,'visible','off');
    set(handles.Cur_edit,'visible','off');  
elseif strcmp(algorithm, 'Depth invariant OSL Algorithm');
    set(handles.text3,'visible','off');
    set(handles.Cur_edit,'visible','off'); 
else
    set(handles.text3,'visible','on');
    set(handles.Cur_edit,'visible','on');    
end



% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Reg_slider_Callback(hObject, eventdata, handles)
% hObject    handle to Reg_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Reg_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Reg_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Reg_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Reg_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Reg_edit as text
%        str2double(get(hObject,'String')) returns contents of Reg_edit as a double


% --- Executes during object creation, after setting all properties.
function Reg_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Reg_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Cur_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Cur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cur_edit as text
%        str2double(get(hObject,'String')) returns contents of Cur_edit as a double


% --- Executes during object creation, after setting all properties.
function Cur_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Iter_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Iter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Iter_edit as text
%        str2double(get(hObject,'String')) returns contents of Iter_edit as a double


% --- Executes during object creation, after setting all properties.
function Iter_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Iter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tol_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Tol_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tol_edit as text
%        str2double(get(hObject,'String')) returns contents of Tol_edit as a double


% --- Executes during object creation, after setting all properties.
function Tol_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tol_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PSF_button.
function PSF_button_Callback(hObject, eventdata, handles)
% hObject    handle to PSF_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hn

myFolder = uigetdir('C:\');
if ~isdir(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
    uiwait(warndlg(errorMessage));
    return;
end
str2 = get( handles.Result_list, 'String' );
str2 = cat( 1, {'- Reading PSF.....'}, str2 );
set(handles.Result_list, 'String',str2);
drawnow;
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.tif'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
if (size(theFiles,1) == 0) % no tif file
    filePattern = fullfile(myFolder, '*.mat'); % Change pattern to read mat file
    theFiles = dir(filePattern);
    if (size(theFiles,1) == 0)
        errorMessage = sprintf('Error: .tif or .mat file does not exist:\n%s', myFolder);
        uiwait(warndlg(errorMessage));
        return;
    end
    hn = length(theFiles);
    for k = 1 : hn
        eval(['global h' num2str(k) ' ']);
        baseFileName = theFiles(k).name;
        fullFileName = fullfile(myFolder, baseFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);
        % Now do whatever you want with this file name,
        % such as reading it in as an image array with imread()
        baseFileNameErase = strrep(baseFileName,'.mat','');
        tmp = load(fullFileName,baseFileNameErase);
        eval(['h' num2str(k) ' =tmp.(baseFileNameErase);']); 
        %eval(['H{1,' num2str(k) '} = load(fullFileName);']);
    end
    handles.PSF_path.String = [];
    str = get( handles.PSF_path, 'String' );
    addstr = ['Reading End. ' num2str(length(theFiles)) ' files from ', myFolder];
    str = cat( 1, {addstr}, str );
    set(handles.PSF_path, 'String',str); 
    
    str2 = get( handles.Result_list, 'String' );
    str2 = cat( 1, {'- Reading PSF End.'}, str2 );
    set(handles.Result_list, 'String',str2);
    drawnow;
else
    hn = length(theFiles);
    for k = 1 : hn
        eval(['global h' num2str(k) ' ']);
        baseFileName = theFiles(k).name;
        fullFileName = fullfile(myFolder, baseFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);
        % Now do whatever you want with this file name,
        % such as reading it in as an image array with imread()
        %eval(['tmp = load(fullFileName, tmpFile' num2str(k) ' ']);
        %eval(['h' num2str(k) ' =tmp.tmpFile' num2str(k) ' ']); 
        eval(['h' num2str(k) ' = imread(fullFileName);']);
    end
    handles.PSF_path.String = [];
    str = get( handles.PSF_path, 'String' );
    addstr = ['Reading End ' num2str(length(theFiles)) ' files from ', myFolder];
    str = cat( 1, {addstr}, str );
    set(handles.PSF_path, 'String',str);
    
    str2 = get( handles.Result_list, 'String' );
    str2 = cat( 1, {'- Reading PSF End.'}, str2 );
    set(handles.Result_list, 'String',str2);
    drawnow;
end


% --- Executes on button press in Img_button.
function Img_button_Callback(hObject, eventdata, handles)
% hObject    handle to Img_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BY
global BYn

myFolder = uigetdir('C:\');
if ~isdir(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
    uiwait(warndlg(errorMessage));
    return;
end
str2 = get( handles.Result_list, 'String' );
str2 = cat( 1, {'- Reading Image.....'}, str2 );
set(handles.Result_list, 'String',str2);
drawnow;
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.tif'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
if (size(theFiles,1) == 0)
    filePattern = fullfile(myFolder, '*.mat'); % Change to whatever pattern you need.
    theFiles = dir(filePattern);
    if (size(theFiles,1) == 0)
        errorMessage = sprintf('Error: .tif or .mat file does not exist:\n%s', myFolder);
        uiwait(warndlg(errorMessage));
        return;
    end
    nz = length(theFiles);
    BYn = nz;
    set(handles.slider6, 'Min', 1);
    set(handles.slider6, 'Max', nz);
    set(handles.Slice_txt, 'String', [num2str(1) '/' num2str(nz)]);
    for k = 1 : length(theFiles)
        baseFileName = theFiles(k).name;
        fullFileName = fullfile(myFolder, baseFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);
        % Now do whatever you want with this file name,
        % such as reading it in as an image array with imread()
        tmp = load(fullFileName, tmpFile);
        BY(:,:,k) = tmp.(tmpFile); 
        %BY(:,:,k)  = load(fullFileName);
        %imshow(BY(:,:,k),[]); % Display image.
        set(handles.slider6, 'Value', k);
        set(handles.Slice_txt, 'String', [num2str(k) '/' num2str(nz)]);
        imshow(BY(:,:,k), [], 'parent', handles.Observe_image);
        drawnow; % Force display to update immediately.
    end
    handles.img_path.String = [];
    str = get( handles.img_path, 'String' );
    addstr = ['Reading End. ' num2str(length(theFiles)) ' files from ', myFolder];
    handles.BY = BY;
    handles.currentBYResult=BY;
    str = cat( 1, {addstr}, str );
    set(handles.img_path, 'String',str);
    str2 = get( handles.Result_list, 'String' );
    str2 = cat( 1, {'- Reading Image End.'}, str2 );
    set(handles.Result_list, 'String',str2);
    drawnow;
    guidata(hObject, handles);
else
    nz = length(theFiles);
    BYn = nz;
    set(handles.slider6, 'Min', 1);
    set(handles.slider6, 'Max', nz);
    set(handles.Slice_txt, 'String', [num2str(1) '/' num2str(nz)]);
    for k = 1 : length(theFiles)
        baseFileName = theFiles(k).name;
        fullFileName = fullfile(myFolder, baseFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);
        % Now do whatever you want with this file name,
        % such as reading it in as an image array with imread()
        BY(:,:,k) = imread(fullFileName);
        set(handles.slider6, 'Value', k);
        set(handles.Slice_txt, 'String', [num2str(k) '/' num2str(nz)]);
        imshow(BY(:,:,k), [], 'parent', handles.Observe_image);
        drawnow; % Force display to update immediately.
    end
    handles.img_path.String = [];
    str = get( handles.img_path, 'String' );
    addstr = ['Reading End. ' num2str(length(theFiles)) ' files from ', myFolder];
    handles.BY = BY;
    handles.currentBYResult=BY;
    str = cat( 1, {addstr}, str );
    set(handles.img_path, 'String',str);
    
    str2 = get( handles.Result_list, 'String' );
    str2 = cat( 1, {'- Reading Image End.'}, str2 );
    set(handles.Result_list, 'String',str2);
    drawnow;
    guidata(hObject, handles);
end



% --- Executes on selection change in Result_list.
function Result_list_Callback(hObject, eventdata, handles)
% hObject    handle to Result_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Result_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Result_lifst


% --- Executes during object creation, after setting all properties.
function Result_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Result_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PSF_path.
function PSF_path_Callback(hObject, eventdata, handles)
% hObject    handle to PSF_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PSF_path contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PSF_path


% --- Executes during object creation, after setting all properties.
function PSF_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PSF_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in img_path.
function img_path_Callback(hObject, eventdata, handles)
% hObject    handle to img_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns img_path contents as cell array
%        contents{get(hObject,'Value')} returns selected item from img_path


% --- Executes during object creation, after setting all properties.
function img_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to img_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'BY')
    BY = handles.currentBYResult;
    nz = size(BY,3);
    current = int32(get(hObject,'Value'));
    set(hObject,'Value', current);
    showBY(hObject, handles, BY, current, nz);
end

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

function showBY(hObject, handles, something, current, nz)
%set(handles.slider6, 'Min', 1);
%set(handles.slider6, 'Max', nz);
%if (current < 1)
%    current = 1;
%end

set(handles.slider6, 'Min', 1);
set(handles.slider6, 'Max', nz);
set(handles.slider6, 'Value', current);
set(handles.slider6, 'SliderStep', [1/nz,10/nz]);
set(handles.Slice_txt, 'String', [num2str(current) '/' num2str(nz)]);
axes(handles.Observe_image);
imshow(something(:,:,current),[], 'parent', handles.Observe_image); 
drawnow;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global Deconv
% nz = size(Deconv,3);
% current = int32(get(hObject,'Value'));
% set(hObject,'Value', current);
% Show_image(hObject, handles, Deconv, current, nz);
if isfield(handles,'currentDeconv')
DeconvResult = handles.currentDeconv;
nz = size(DeconvResult,3);
current = int32(get(hObject,'Value'));
set(hObject,'Value',current);
showDeconv(hObject, handles, DeconvResult, current, nz);
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function Show_image(hObject, handles, Result, current, nz)

set(handles.slider7, 'Min', 1);
set(handles.slider7, 'Max', nz);
set(handles.slider7, 'Value', current);
set(handles.slider7, 'SliderStep', [1/nz,10/nz]);
set(handles.Slice_txt2, 'String', [num2str(current) '/' num2str(nz)]);
axes(handles.Result_image);
imshow(Result(:,:,current),[], 'parent', handles.Result_image); 
drawnow;
guidata(hObject, handles);



% --- Executes on button press in Run_button.
function Run_button_Callback(hObject, eventdata, handles)
% hObject    handle to Run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BY
global algorithm
global Deconv
global H
global hn
global BYn
global Every_save_check
global file_type

if ((hn ~= BYn) && (strcmp(algorithm, 'Depth variant OSL Algorithm')) && (strcmp(algorithm, 'Depth variant GEM Algorithm')))
    errorMessage = sprintf('Error: the number of PSFs and the number of Observed images do not match:\n #PSF = %s, #Observed Image = %s', hn, BYn);
    uiwait(warndlg(errorMessage));
end
if strcmp(algorithm, 'Depth variant OSL Algorithm')
    str = get( handles.Result_list, 'String' );
    str = cat( 1, {'- DV OSL Running start.....'}, str );
    set(handles.Result_list, 'String',str);
    drawnow;
    for k=1:BYn
        eval(['global h' num2str(k) ' ']); 
        eval(['H{k} = h' num2str(k) ';']);
    end
    a =  str2num(get(handles.Reg_edit,'String'));
    iter = str2num(get(handles.Iter_edit,'String'));
    tic;
    Deconv = DV_OSL(BY, H, a, iter, Every_save_check, file_type);
    t = toc;
    addstr = ['- End, running time: ' num2str(t) 's'];
    str = cat( 1, {addstr}, str );
    set(handles.Result_list, 'String',str);
    %display
    current = floor(BYn/2);
    Show_image(hObject, handles, Deconv, current, BYn);
    handles.Deconv = Deconv;
    handles.currentDeconv = Deconv;
    isfield(handles,'Deconv');
    guidata(hObject, handles);
elseif strcmp(algorithm, 'Depth variant GEM Algorithm')
    str = get( handles.Result_list, 'String' );
    str = cat( 1, {'- DV GEM Running start.....'}, str );
    set(handles.Result_list, 'String',str);
    drawnow;
    for k=1:BYn
        eval(['global h' num2str(k) ' ']); 
        eval(['H{k} = h' num2str(k) ';']);
    end
    curv = str2num(get(handles.Cur_edit,'String'));
    a = str2num(get(handles.Reg_edit,'String'));
    iter = str2num(get(handles.Iter_edit,'String'));
    tic;
    Deconv = DV_GEM(BY, H, curv, a, iter, Every_save_check, file_type);
    t = toc;
    addstr = ['- End, running time: ' num2str(t) 's'];
    str = cat( 1, {addstr}, str );
    set(handles.Result_list, 'String',str);
    %display
    current = floor(BYn/2);
    Show_image(hObject, handles, Deconv, current, BYn);
    handles.Deconv = Deconv;
    handles.currentDeconv = Deconv;
    isfield(handles,'Deconv');
    guidata(hObject, handles);
elseif strcmp(algorithm, 'Depth invariant GEM Algorithm')
    str = get( handles.Result_list, 'String' );
    str = cat( 1, {'- GEM Running start.....'}, str );
    set(handles.Result_list, 'String',str);
    drawnow;
    for k=1:hn
        eval(['global h' num2str(k) ' ']); 
        eval(['H = h' num2str(k) ';']);
    end
    curv = str2num(get(handles.Cur_edit,'String'));
    a = str2num(get(handles.Reg_edit,'String'));
    iter = str2num(get(handles.Iter_edit,'String'));
    tic;
    Deconv = INV_GEM(BY, H, curv, a, iter, Every_save_check, file_type);
    t = toc;
    addstr = ['- End, running time: ' num2str(t) 's'];
    str = cat( 1, {addstr}, str );
    set(handles.Result_list, 'String',str);
    %display
    current = floor(BYn/2);
    Show_image(hObject, handles, Deconv, current, BYn);
    handles.Deconv = Deconv;
    handles.currentDeconv = Deconv;
    isfield(handles,'Deconv');
    guidata(hObject, handles);
else
    str = get( handles.Result_list, 'String' );
    str = cat( 1, {'- OSL Running start.....'}, str );
    set(handles.Result_list, 'String',str);
    drawnow;
    for k=1:hn
        eval(['global h' num2str(k) ' ']); 
        eval(['H = h' num2str(k) ';']);
    end
    a = str2num(get(handles.Reg_edit,'String'));
    iter = str2num(get(handles.Iter_edit,'String'));
    tic;
    Deconv = INV_OSL(BY, H, a, iter, Every_save_check, file_type);
    t = toc;
    addstr = ['- End, running time: ' num2str(t) 's'];
    str = cat( 1, {addstr}, str );
    set(handles.Result_list, 'String',str);
    %display
    current = floor(BYn/2);
    handles.Deconv = Deconv;
    handles.currentDeconv = Deconv;
    isfield(handles,'Deconv');
    guidata(hObject, handles);
    Show_image(hObject, handles, Deconv, current, BYn);
end
