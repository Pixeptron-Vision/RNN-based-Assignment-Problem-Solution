function varargout = Assignment_OR(varargin)
% ASSIGNMENT_OR MATLAB code for Assignment_OR.fig
%      ASSIGNMENT_OR, by itself, creates a new ASSIGNMENT_OR or raises the existing
%      singleton*.
%
%      H = ASSIGNMENT_OR returns the handle to a new ASSIGNMENT_OR or the handle to
%      the existing singleton*.
%
%      ASSIGNMENT_OR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASSIGNMENT_OR.M with the given input arguments.
%
%      ASSIGNMENT_OR('Property','Value',...) creates a new ASSIGNMENT_OR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Assignment_OR_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Assignment_OR_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Assignment_OR

% Last Modified by GUIDE v2.5 18-Apr-2016 00:39:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Assignment_OR_OpeningFcn, ...
                   'gui_OutputFcn',  @Assignment_OR_OutputFcn, ...
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


% --- Executes just before Assignment_OR is made visible.
function Assignment_OR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Assignment_OR (see VARARGIN)

% Choose default command line output for Assignment_OR
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Assignment_OR wait for user response (see UIRESUME)
% uiwait(handles.edit1);


% --- Outputs from this function are returned to the command line.
function varargout = Assignment_OR_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

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

c=str2num(get(hObject,'String'));
% disp(c)
p=sqrt(length(c));
for count=1:p
    C(count,1:p)=c(1,((count-1)*p+1):count*p);
end
%construction of matrix A
try I= eye(p);
catch
    set(handles.edit3,'String','Error parsing the cost matrix input entered. Input must be a square matrix!')
end

A2=repmat(I,1,p);
for count=1:p
    Bm=zeros(p,p);
    Bm(count,:)=1;
    if count ==1
        A1=Bm;
    end
    if(count >1)
        A1=cat(2,A1,Bm);
    end
end
A=[A2;A1];
W=A'*A;
b=ones(2*p,1);
x=b\A;
theta=ones(p^2,1);
theta=2*theta;
%parameters of Neural Net
beta=2.5;
eta=1;
try (get(handles.edit4,'String'));
    tou=num2str(get(handles.edit4,'String'));    
    tou=str2num(tou);
    if isempty(tou)
      set(handles.edit3,'String','Enter valid T-value and Epoch Limit and then enter the cost matrix!');
    end  
catch
    tou=150;
end
lambda=eta/max(max(C));
theta1=theta';
for count=1:p
    X(count,1:p)=x(1,((count-1)*p+1):count*p);
end
for count=1:p
    Theta(count,1:p)=theta1(1,((count-1)*p+1):count*p);
end
%initialization of neurons
try(get(handles.edit5,'String'));
  epochlimit=num2str(get(handles.edit5,'String'));
  if isempty(epochlimit)
      set(handles.edit3,'String','Enter valid T-value and Epoch Limit and then enter the cost matrix!');
  end 
  epochlimit=str2num(epochlimit);
catch
  epochlimit=0;
end
U=zeros(p,p);
error=0.8;
epoch=0;
x=zeros(1,length(x));
X=zeros(p,p);
er=abs(sum(W*x'-theta));
if ~(isempty(tou) & isempty(epochlimit))
    while(er >error && epoch < epochlimit)
        for i=1:p
            for j=1:p
                U1(i,j)=U(i,j)+(-eta*sum(X(i,1:p))-eta*sum(X(1:p,j))+eta*Theta(i,j)-lambda*C(i,j)*exp(-1/tou));
                X(i,j)=1/(1+exp(-beta*U1(i,j)));
            end
        end
        for num=1:p
            x(1,(num-1)*p+1:num*p)=X(num,:);
        end
        U=U1;
        epoch=epoch+1;
        % disp(epoch)
        er=abs(sum(W*x'-theta));
    end
    m=1;
    x_bar=X;
    x_one=X;
    Mat=zeros(9,3);
    while( m<= p)
        % disp('here')
        km=max(max(x_bar));
        [k,l]=find(x_bar==km);
        Mat(m,1)=k;Mat(m,2)=l;
        mem=0.5*(sum(x_bar(k,:)+sum(x_bar(:,l))))   ;
        Mat(m,3)=mem;
        x_bar(:,l)=0;
        x_bar(k,:)=0;
        x_one=x_bar;
        x_one(k,l)=mem;  
        m=m+1;
    end
    x_one=zeros(p,p);
    for num=1:p
        x_one(Mat(num,1),Mat(num,2))=Mat(num,3);
    end
    C1=C;
    for  i=1:p
        for j=1:p
            if(x_one(i,j)==0)
                C1(i,j)=0;
            end
        end
    end
    handles.C1=C1;
    handles.tou=tou;
    handles.epochlimit=epochlimit;
    set(handles.edit3,'String',num2str(handles.C1));   
end
guidata(hObject, handles);

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

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
%C1=handles.C1;
try C1
    set(handles.edit3,'String',num2str(C1)); 
catch
    set(handles.edit3,'String','Wrong Expression');
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% pushbutton_4 in UI is disabled for this Application. 


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% pushbutton_6 in the UI is Disabled. 



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
