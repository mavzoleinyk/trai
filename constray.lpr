program constray;

{$AppType GUI}

uses
  windows, Messages, ShellApi, SysUtils;

const
  Ico_Message = WM_USER;

var
  Instance: HWND;
  WindowClass: TWNDCLASS;
  FHandle: HWND;
  mesg: TMSG;
  noIconData: TNOTIFYICONDATA;
  HIcon1: HICON;
  WindowHandle, EditHandle: HWND;

function WindowProc(Hwn: HWND; msg: uint; wpr: WPARAM; lpr: LPARAM): LRESULT; stdcall;
begin
  Result := 0;
  case msg of
    WM_DESTROY:
    begin
      PostQuitMessage(0);
    end;

    WM_KEYDOWN:
    begin

    end;

    Ico_Message:
    begin
      case lpr of
        WM_LBUTTONDOWN:
        begin
          ShowWindow(FHandle, SW_SHOW);
          UpdateWindow(FHandle);
        end;
        WM_RBUTTONDOWN:
          ShowWindow(FHandle, SW_HIDE);
      end;
    end;

    WM_CLOSE:
    begin
      ShowWindow(FHandle, SW_HIDE);
    end;

    WM_HOTKEY:
    begin
      if wpr = 1 then
      begin
        WindowHandle := GetForegroundWindow;
        EditHandle := GetTopWindow(WindowHandle);
        PostMessage(EditHandle, WM_KEYDOWN, VK_CONTROL, $001D0001);
        PostMessage(EditHandle, WM_KEYDOWN, ord('C'), $002E0001);
        SendMessage(EditHandle, WM_COMMAND, $00010043, $00000000);
        PostQuitMessage(0);
      end;
    end;

    else
      Result := DefWindowProc(hwn, msg, wpr, lpr);
  end;
end;

procedure CreateMyicon;
begin
  HIcon1 := LoadIcon(Instance, 'MAINICON');
  with noIconData do begin
    cbSize := SizeOf(TNOTIFYICONDATA);
    hWnd := FHandle; //Изначальный параметр wnd!
    uID := 0;
    UFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
    SzTip := 'constray';
    hIcon := HIcon1;
    uCallbackMessage := Ico_Message;
  end;
  Shell_NotifyIconA(NIM_ADD, @noIconData);
end;

procedure DestroyMyicon;
begin
  ShellApi.Shell_NotifyIconA(NIM_DELETE, @noIconData);
end;

{$R *.res}

begin
  Instance := GetModuleHandle(nil);
  with WindowClass do
  begin
    style := CS_HREDRAW or CS_VREDRAW;
    lpfnWndProc := @WindowProc;
    hInstance := Instance;
    hbrBackground := COLOR_BTNFACE;
    lpszClassName := 'DX';
    //hCursor := LoadIcon(0, IDI_HAND);
  end;

  RegisterClass(WindowClass);

  FHandle := CreateWindowEx(0, 'DX', '', WS_OVERLAPPEDWINDOW, 5,5, 200, 200, 0,0,Instance, nil);
  RegisterHotKey(FHandle, 1, MOD_CONTROL or $4000, VK_F12);
  CreateMyicon;

  while (GetMessage(mesg, 0,0,0)) do
  begin
    TranslateMessage(mesg);
    DispatchMessage(mesg);
  end;
  DestroyMyicon;
end.



