#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <algorithm>

#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  Win32Window::Size min_size(1000, 600); // Minimum size to avoid mobile UI
  if (!window.Create(L"dester", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);
  
  // Set minimum window size
  HWND hwnd = window.GetHandle();
  if (hwnd) {
    RECT rect;
    GetWindowRect(hwnd, &rect);
    SetWindowPos(hwnd, nullptr, rect.left, rect.top, 
                 std::max(rect.right - rect.left, (LONG)min_size.width),
                 std::max(rect.bottom - rect.top, (LONG)min_size.height),
                 SWP_NOZORDER | SWP_NOMOVE);
  }

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
