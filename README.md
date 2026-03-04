# ASUS Copilot Key Fix (Remap to Right Ctrl)

## The Problem

Many ASUS laptops (2024+) replaced the **Right Ctrl** key with a **Copilot** key. Pressing it launches Microsoft Copilot instead of acting as a modifier -- making it useless for keyboard shortcuts, gaming, or any workflow that depends on Right Ctrl.

## Why Most "Fixes" Don't Work

The Copilot key does **not** send a single keycode. It sends **three separate key events** in rapid succession (~1ms apart):

```
1. LWin down
2. LShift down
3. F23 down      (scan code 0x06E)
```

Most remapping guides online only remap **F23** to another key. This fails because:

- **LWin** still reaches the OS, triggering the Start menu or Windows shortcuts.
- **LShift** still reaches the OS, modifying other key presses.
- By the time F23 arrives, the damage is already done.

Remapping F23 alone is like locking the back door while leaving the front door wide open.

## How This Fix Actually Works

This fix uses a **3-state interception approach** at the keyboard hook level:

1. **Intercept LWin** -- When LWin is pressed, the script does **not** pass it to the OS. Instead, it enters a `"waiting"` state and starts a 30ms timer.

2. **Intercept LShift** -- If LShift arrives while in the `"waiting"` state (i.e., right after LWin), it is also suppressed.

3. **Check for F23** -- Two outcomes:
   - **F23 arrives within 30ms**: This confirms it was the Copilot key. The script cancels the timer, discards LWin and LShift entirely, and sends **RCtrl** instead.
   - **F23 does NOT arrive within 30ms**: This was a real LWin press (and possibly LShift). The timer fires, and the script passes the original key(s) through to the OS normally.

The result: the Copilot key becomes Right Ctrl, and all other keys (including Win and Shift) work exactly as expected.

## Requirements

- **Windows 10 / 11**
- **[AutoHotkey v2](https://www.autohotkey.com/)** (v2.0 or newer -- v1.x is NOT compatible)

## Installation

### Automatic (Recommended)

1. Install [AutoHotkey v2](https://www.autohotkey.com/).
2. Download or clone this repository.
3. Right-click `instalar.ps1` and select **Run with PowerShell**.

This will:
- Create a startup shortcut so the fix runs automatically on every boot.
- Launch the fix immediately.

### Manual

1. Install [AutoHotkey v2](https://www.autohotkey.com/).
2. Double-click `copilot_a_ctrl.ahk` to run the fix.
3. (Optional) To run on startup, create a shortcut to `copilot_a_ctrl.ahk` in your Startup folder:
   - Press `Win+R`, type `shell:startup`, press Enter.
   - Copy a shortcut of `copilot_a_ctrl.ahk` into that folder.

### Verifying It Works

After running the fix, press the Copilot key. It should now behave as Right Ctrl. You can test by pressing Copilot + C (should copy, not launch Copilot).

## Diagnosing Your Key (detectar_tecla.ps1)

Not all ASUS models necessarily send the same key codes. The `detectar_tecla.ps1` script is a low-level keyboard hook diagnostic that shows you **exactly** what your Copilot key sends.

### How to Use

1. Right-click `detectar_tecla.ps1` and select **Run with PowerShell**.
2. Press the Copilot key (and any other keys for comparison).
3. The script will display the virtual key code, scan code, and flags for each key event.
4. Press `Ctrl+C` to exit.

### Expected Output for the Copilot Key

If your laptop matches the known pattern, you should see three rapid events:

```
VK: 0x005B (91)   |  ScanCode: 0x015B (347)  |  Flags: 0x0001 (Extended)  |  Name: LeftWindows
VK: 0x00A0 (160)  |  ScanCode: 0x002A (42)   |  Flags: 0x0000            |  Name: ...
VK: 0x0086 (134)  |  ScanCode: 0x006E (110)  |  Flags: 0x0000            |  Name: ...
```

If your output looks different, please open an issue with your model name and the output -- this will help us support more devices.

## Known Caveats

- **~30ms delay on the Win key**: The script holds LWin for up to 30ms before passing it through. This delay is imperceptible in normal use.
- **Very fast Win+Shift combos**: If you press Win and Shift within a 30ms window, the Shift press might be suppressed until the timer fires. In practice this is extremely rare and does not affect normal usage.
- **Requires AHK v2**: The script uses AutoHotkey v2 syntax. It will not run on AHK v1.x. Make sure you install the correct version.
- **One instance only**: The script enforces `#SingleInstance Force`, so running it again will replace the previous instance rather than creating duplicates.

## Tested On

| Model | Status | Notes |
|-------|--------|-------|
| ASUS Zenbook S 16 (UM5606) | Verified | Copilot key sends LWin+LShift+F23. Fix works perfectly. |

See [SUPPORTED_DEVICES.md](SUPPORTED_DEVICES.md) for a full list of laptops known to have the Copilot key.

We need your help testing on more devices. See the Contributing section below.

## Contributing

Contributions are welcome! Here is how you can help:

1. **Test on your ASUS laptop** -- Run `detectar_tecla.ps1`, note your laptop model, and report whether the fix works. Open an issue or PR to add your model to the "Tested On" table.

2. **Different key codes** -- If your ASUS laptop sends different codes for the Copilot key, share the output of `detectar_tecla.ps1` so we can add support for your model.

3. **Bug reports** -- If the fix causes issues with specific software or key combinations, please open an issue with details.

4. **Translations** -- The scripts have comments in Spanish. If you want to help translate them or add documentation in other languages, PRs are welcome.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
