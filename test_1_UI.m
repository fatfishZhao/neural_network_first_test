function varargout = test_1_UI(varargin)
% TEST_1_UI MATLAB code for test_1_UI.fig
%      TEST_1_UI, by itself, creates a new TEST_1_UI or raises the existing
%      singleton*.
%
%      H = TEST_1_UI returns the handle to a new TEST_1_UI or the handle to
%      the existing singleton*.
%
%      TEST_1_UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_1_UI.M with the given input arguments.
%
%      TEST_1_UI('Property','Value',...) creates a new TEST_1_UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_1_UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_1_UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test_1_UI

% Last Modified by GUIDE v2.5 12-Dec-2017 16:02:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_1_UI_OpeningFcn, ...
                   'gui_OutputFcn',  @test_1_UI_OutputFcn, ...
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


% --- Executes just before test_1_UI is made visible.
function test_1_UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test_1_UI (see VARARGIN)

% Choose default command line output for test_1_UI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
load('lms_samp','samp');
load('lms_tstsamp.mat','tstsamp');
global Emin X Y testX testY W_SGD W_SGD_mini;
X = [ones(size(samp,1),1),samp(:,1:2)];
Y = samp(:,3);
testX = [ones(size(tstsamp,1),1),tstsamp(:,1:2)];
testY = tstsamp(:,3);
Emin = 0.2617;%提前声明Emin
W_SGD = [1,1,1];%初始化
W_SGD_mini = [1,1,1];%初始化

% UIWAIT makes test_1_UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_1_UI_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('请等待')
method = get(get(handles.uibuttongroup2,'SelectedObject'), 'String');
global Emin W_SGD W_SGD_mini X Y;
SColor = zeros(size(X,1),3);
SColor(Y==1,3) = 1;
SColor(Y==-1,1) = 1;
switch method
    case 'LMS'
        %计算自相关矩阵R
        sumR = zeros(3);
        for i=1:size(X,1)
            sumR = sumR + X(i,:)'*X(i,:);
        end
        R = sumR/size(X,1);
        %计算互相关向量P
        P = mean(X(:,:).*repmat(Y,[1,3]));
        %计算最佳权值向量Wstar
        Wstar = P*R^-1;
        %最小均方误差Emin
        neural_a = neural_2(Wstar);
        errorSum = 0;
        for i=1:size(X,1)
            y = neural_a.goThrough(X(i,:));
            errorSum = errorSum + (y-Y(i,1))^2;
        end
        Emin = errorSum/size(X,1);
        set(handles.text2,'String',['最小均方误差为',num2str(Emin)]);
        scatter(handles.axes1,X(:,2),X(:,3),5,SColor);
        line(handles.axes1,[-4,4],[(4*Wstar(2)-Wstar(1))/Wstar(3),(-4*Wstar(2)-Wstar(1))/Wstar(3)]);
    case '随机逼近算法'
        alpha = str2double(get(handles.edit1,'String'));
        set(handles.text2,'String','');
        if isnan(alpha)
            set(handles.text2,'String','未输入alpha，默认值为0.01');
            alpha = 0.01;
        end
        Estop = Emin+0.001;
        [W_SGD,Elog] = SGD_mini(X,Y,alpha,Estop,1);
        set(handles.axes2,'NextPlot','add');
        plot(handles.axes2,Elog,'DisplayName',['alpha = ',num2str(alpha)]);legend('show')
        scatter(handles.axes1,X(:,2),X(:,3),5,SColor);
        line(handles.axes1,[-4,4],[(4*W_SGD(2)-W_SGD(1))/W_SGD(3),(-4*W_SGD(2)-W_SGD(1))/W_SGD(3)]);
        set(handles.text2,'String',[get(handles.text2,'String'),'W为',num2str(W_SGD)]);
        %kk
    case '基于统计的算法'
        alpha = str2double(get(handles.edit1,'String'));
        set(handles.text2,'String','');
        if isnan(alpha)
            set(handles.text2,'String','未输入alpha，默认值为0.01');
            alpha = 0.01;
        else
            set(handles.text2,'String','');
        end
        P = str2double(get(handles.edit2,'String'));
        if isnan(P)
            set(handles.text2,'String',[get(handles.text2,'String'),'未输入P，默认值为5']);
            P = 5;
        end
        Estop = Emin+0.001;
        [W_SGD_mini,Elog] = SGD_mini(X,Y,alpha,Estop,P);
        set(handles.axes2,'NextPlot','add');
        plot(handles.axes2,Elog,'DisplayName',['alpha = ',num2str(alpha),',P=',num2str(P)]);legend('show')
        scatter(handles.axes1,X(:,2),X(:,3),5,SColor);
        line(handles.axes1,[-4,4],[(4*W_SGD_mini(2)-W_SGD_mini(1))/W_SGD_mini(3),(-4*W_SGD_mini(2)-W_SGD_mini(1))/W_SGD_mini(3)]);
        set(handles.text2,'String',[get(handles.text2,'String'),'W为',num2str(W_SGD_mini)]);
    case 'Widrow'
        alpha = str2double(get(handles.edit1,'String'));
        set(handles.text2,'String','');
        if isnan(alpha)
            set(handles.text2,'String','未输入alpha，默认值为0.1');
            alpha=0.1;
        end
        Estop = Emin+0.001;
        P = size(X,1);
        [W_SGD_mini,Elog] = SGD_mini(X,Y,alpha,Estop,P);
        set(handles.axes2,'NextPlot','add');
        plot(handles.axes2,Elog,'DisplayName',['alpha = ',num2str(alpha),',P=',num2str(P)]);legend('show')
        scatter(handles.axes1,X(:,2),X(:,3),5,SColor);
        line(handles.axes1,[-4,4],[(4*W_SGD_mini(2)-W_SGD_mini(1))/W_SGD_mini(3),(-4*W_SGD_mini(2)-W_SGD_mini(1))/W_SGD_mini(3)]);
        set(handles.text2,'String',[get(handles.text2,'String'),'W为',num2str(W_SGD_mini)]);
    otherwise
        error('方法选择出错')
end
disp('计算结束')


% --- Executes on button press in pushbutton2.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global W_SGD testX testY;
SColor = zeros(size(testX,1),3);
SColor(testY==1,3) = 1;
SColor(testY==-1,1) = 1;
scatter(handles.axes1,testX(:,2),testX(:,3),5,SColor);
line(handles.axes1,[-4,4],[(4*W_SGD(2)-W_SGD(1))/W_SGD(3),(-4*W_SGD(2)-W_SGD(1))/W_SGD(3)]);
neural_SGD = neural_2(W_SGD);
Y_SGD = neural_SGD.goThrough_th(testX);
set(handles.text2,'String',['随机梯度下降法正确率是',num2str(1-size(find(testY'~=Y_SGD),2)/size(testX,1))]);



% --- Executes on button press in pushbutton2.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tstsamp W_SGD_mini testX testY;
SColor = zeros(size(testX,1),3);
SColor(testY==1,3) = 1;
SColor(testY==-1,1) = 1;
scatter(handles.axes1,testX(:,2),testX(:,3),5,SColor);
line(handles.axes1,[-4,4],[(4*W_SGD_mini(2)-W_SGD_mini(1))/W_SGD_mini(3),(-4*W_SGD_mini(2)-W_SGD_mini(1))/W_SGD_mini(3)]);
neural_SGD = neural_2(W_SGD_mini);
Y_SGD_mini = neural_SGD.goThrough_th(testX);
set(handles.text2,'String',['统计梯度下降法正确率是',num2str(1-size(find(testY'~=Y_SGD_mini),2)/size(testX,1))]);



% --- Executes on button press in pushbutton4.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'String','');
cla(handles.axes1,'reset')
cla(handles.axes2,'reset')
%清除图像cla
