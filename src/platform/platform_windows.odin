#+build windows
package platform

import win "core:sys/windows"

import mem "src:basic/mem"

@(private)
windows_create_window :: proc(
	title:  string, 
	width:  int, 
	height: int, 
	arena:  ^mem.Arena
) -> Window
{
  result: Window

	temp := mem.begin_temp(mem.get_scratch())
	defer mem.end_temp(temp)

  title_utf16 := &win.utf8_to_utf16(title)[0]

  win.SetProcessDPIAware()

  instance := win.HINSTANCE(win.GetModuleHandleW(nil))
  window_class := win.WNDCLASSW{
    lpfnWndProc = window_proc,
    lpszClassName = title_utf16,
    hInstance = instance,
  }

  win.RegisterClassW(&window_class)
  hwnd := win.CreateWindowW(lpClassName=title_utf16, 
                            lpWindowName=title_utf16, 
                            dwStyle=win.WS_OVERLAPPEDWINDOW | win.WS_VISIBLE, 
                            X=100, 
                            Y=100, 
                            nWidth=1280, 
                            nHeight=720,
                            hWndParent=nil,
                            hMenu=nil,
                            hInstance=instance,
                            lpParam=nil
  )

  win.SetForegroundWindow(hwnd)
  result.handle = hwnd

  return result
}

@(private)
windows_release_os_resources :: proc(window: ^Window)
{
  win.DestroyWindow(cast(win.HWND) window.handle)
}

@(private)
windows_poll_event :: proc(window: ^Window, event: ^Event) -> bool
{
	result: bool
  
  ev := pop_event(&window.event_queue)
  if ev != nil
  {
    event^ = ev^
    result = true
  }

	return result
}

@(private)
windows_pump_events :: proc(window: ^Window)
{
  msg: win.MSG

  for win.PeekMessageW(&msg, nil, 0, 0, win.PM_REMOVE)
  {
    if (msg.message == win.WM_QUIT)
    {
      push_event(&window.event_queue, Event{kind=.QUIT})
    }

    win.DispatchMessageW(&msg)
  }
}

@(private="file")
window_proc :: proc "stdcall" (
  hwnd:   win.HWND, 
  msg:    win.UINT, 
  wparam: win.WPARAM,
  lparam: win.LPARAM
) -> win.LRESULT
{
  switch msg
  {
  case win.WM_DESTROY:
    win.PostQuitMessage(0)
    return 0
  }

  return win.DefWindowProcW(hwnd, msg, wparam, lparam)
}
