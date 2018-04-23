function varargout = GUIWatermarking(varargin)
% GUIWATERMARKING MATLAB code for GUIWatermarking.fig
%      GUIWATERMARKING, by itself, creates a new GUIWATERMARKING or raises the existing
%      singleton*.
%
%      H = GUIWATERMARKING returns the handle to a new GUIWATERMARKING or the handle to
%      the existing singleton*.
%
%      GUIWATERMARKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIWATERMARKING.M with the given input arguments.
%
%      GUIWATERMARKING('Property','Value',...) creates a new GUIWATERMARKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIWatermarking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIWatermarking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIWatermarking

% Last Modified by GUIDE v2.5 22-Nov-2017 18:31:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIWatermarking_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIWatermarking_OutputFcn, ...
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


% --- Executes just before GUIWatermarking is made visible.
function GUIWatermarking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIWatermarking (see VARARGIN)

% Choose default command line output for GUIWatermarking
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIWatermarking wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIWatermarking_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[baseFilename, folder] =uigetfile('*.*', 'Specify the image location');
FullimageFileName= fullfile(folder,baseFilename);
image = imread(FullimageFileName);
axes(handles.axes1);
imshow(image);
axis equal;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cover_object=getimage(handles.axes1);
Embed_watermark = Embedding(cover_object);
axes(handles.axes2);
imshow(uint8(Embed_watermark));
axis equal;

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cover_object=getimage(handles.axes1);
Embed_watermark = Embedding(cover_object);
noisy = imnoise(Embed_watermark,'salt & pepper',0.03);
imwrite(noisy,'5.jpg','jpg', 'quality', 50);
imwrite(noisy,'lsb_watermarked_noise.bmp','bmp');
axes(handles.axes2);
imshow(noisy,[]);
axis equal;
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cover_object=getimage(handles.axes1);
Embed_watermark = Embedding(cover_object);
noisy = imnoise(Embed_watermark,'gaussian',0.03);
imwrite(noisy,'5.jpg','jpg', 'quality', 50);
imwrite(noisy,'lsb_watermarked_noise.bmp','bmp');
axes(handles.axes2);
imshow(noisy,[]);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
watermarked_image=getimage(handles.axes2);
Mw=size(watermarked_image,1);	%Height 
Nw=size(watermarked_image,2);	%Width
size_host=Mw*Nw;
key=9999;
rand('twister',key); % Mersene Twister is used to randomize 
R=rand([size_host,6]);
RS=round(R);
for i=1:size_host
    if(RS(i,1)==0 && RS(i,2)==1 && RS(i,3)==0 && RS(i,4)==1 && RS(i,5)==0 && RS(i,6)==1 && RS(i,7)==0 )
        RS(i,7)= 0;
    else
        RS(i,7)=1;
    end
end
size_watermark=1875;
Mm=25;
Nm=75;
u=1;i=1;
% use lsb of watermarked image to recover watermark 
for ii = 1:Mw 
for jj = 1:Nw 
    if(u<=size_watermark && RS(i,7)==0)
        watermark(u)=bitget(watermarked_image(ii,jj),6); 
        u=u+1;
    end
        i=i+1;
end 
end

watermark=reshape(watermark(1:size_watermark),Mm,Nm);
axes(handles.axes3);
imshow(watermark,[]);
axis equal;

message2=watermark;
WM_image = imread('ump2.bmp');
WM_image = im2bw(WM_image,0.6);
WM_image = double(WM_image);
message2 = double(message2);

p = WM_image.*message2;
Q = sum(sum(p));
O = sqrt(sum(sum(WM_image.^2)))*sqrt(sum(sum(message2.^2)));
NC = Q/O;

[K,L] = size(WM_image);
BCR = 1-sum(xor(WM_image(:),message2(:)))/(K*L);
set(handles.edit1,'String',num2str(NC));
set(handles.edit2,'String',num2str(BCR));

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
