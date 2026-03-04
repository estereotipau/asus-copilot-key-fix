Add-Type -AssemblyName System.Windows.Forms

Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Diagnostics;

public class KeyDetector {
    private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll", SetLastError = true)]
    private static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool UnhookWindowsHookEx(IntPtr hhk);

    [DllImport("user32.dll")]
    private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

    [DllImport("kernel32.dll")]
    private static extern IntPtr GetModuleHandle(string lpModuleName);

    private const int WH_KEYBOARD_LL = 13;
    private const int WM_KEYDOWN = 0x0100;
    private const int WM_SYSKEYDOWN = 0x0104;

    private static IntPtr hookId = IntPtr.Zero;
    private static LowLevelKeyboardProc proc = HookCallback;

    [StructLayout(LayoutKind.Sequential)]
    private struct KBDLLHOOKSTRUCT {
        public uint vkCode;
        public uint scanCode;
        public uint flags;
        public uint time;
        public IntPtr dwExtraInfo;
    }

    public static void Start() {
        using (Process curProcess = Process.GetCurrentProcess())
        using (ProcessModule curModule = curProcess.MainModule) {
            hookId = SetWindowsHookEx(WH_KEYBOARD_LL, proc, GetModuleHandle(curModule.ModuleName), 0);
        }
    }

    public static void Stop() {
        UnhookWindowsHookEx(hookId);
    }

    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) {
        if (nCode >= 0 && (wParam == (IntPtr)WM_KEYDOWN || wParam == (IntPtr)WM_SYSKEYDOWN)) {
            KBDLLHOOKSTRUCT info = Marshal.PtrToStructure<KBDLLHOOKSTRUCT>(lParam);
            bool extended = (info.flags & 0x01) != 0;
            string extText = extended ? " (Extended)" : "";
            Console.WriteLine(
                "VK: 0x{0:X4} ({0})  |  ScanCode: 0x{1:X4} ({1})  |  Flags: 0x{2:X4}{3}  |  Nombre: {4}",
                info.vkCode, info.scanCode, info.flags, extText,
                Enum.IsDefined(typeof(ConsoleKey), (int)info.vkCode) ? ((ConsoleKey)info.vkCode).ToString() : "Desconocido"
            );
        }
        return CallNextHookEx(hookId, nCode, wParam, lParam);
    }
}
"@

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  DETECTOR DE TECLA COPILOT - ASUS FIX" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Presiona la tecla COPILOT (y cualquier otra tecla para comparar)." -ForegroundColor Yellow
Write-Host "Presiona Ctrl+C para salir." -ForegroundColor Yellow
Write-Host ""
Write-Host "Esperando teclas..." -ForegroundColor Green
Write-Host ""

[KeyDetector]::Start()

try {
    while ($true) {
        [System.Windows.Forms.Application]::DoEvents()
        Start-Sleep -Milliseconds 50
    }
} finally {
    [KeyDetector]::Stop()
}
