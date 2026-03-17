# Supported / Affected Devices

All known Copilot keys send **LWin + LShift + F23** regardless of brand. This is a Microsoft specification, not a per-OEM choice. If your laptop has a Copilot key, this fix should work.

## Verified

These devices have been tested and confirmed working with this fix:

| Brand | Model | Key Replaced | Status |
|-------|-------|-------------|--------|
| ASUS | Zenbook S 16 (UM5606) | Right Ctrl | Verified |
| Lenovo | IdeaPad Slim 5 (15ARP10) | Right Ctrl | Verified |

## Likely Compatible

These devices are known to have the Copilot key and should work with this fix (same LWin+LShift+F23 signal). If you own one, please test and report back.

### ASUS

| Model | Key Replaced | Notes |
|-------|-------------|-------|
| ProArt P16 (H7606) | Right Ctrl | AMD Ryzen AI 9 HX 370 |
| ProArt PX13 | Right Ctrl | 13" convertible |
| ProArt PZ13 | Right Ctrl | 13" detachable, Snapdragon X |
| Zenbook S 14 (UX5406) | Right Ctrl | |
| Zenbook A14 | Right Ctrl | Snapdragon X |
| Vivobook S 14 (M5406) | Right Ctrl | AMD Ryzen AI 9 |
| Vivobook S 15 (S5507) | Right Ctrl | Snapdragon X Elite |
| Vivobook S 15 (M5506) | Right Ctrl | AMD Ryzen AI 9 |
| Vivobook S 16 (M5606) | Right Ctrl | AMD Ryzen AI 9 |
| ROG Zephyrus G14 (GA403) | Right Ctrl | 2024 model |
| ROG Zephyrus G16 (GU605) | Right Ctrl | 2024 model |
| TUF Gaming A14 | Right Ctrl | AMD Ryzen AI 300 |
| TUF Gaming A16 | Right Ctrl | AMD Ryzen AI 300 |

### Dell

| Model | Key Replaced | Notes |
|-------|-------------|-------|
| XPS 13 (9340) | Right Ctrl / Menu | |
| XPS 14 (9440) | Right Ctrl / Menu | |
| XPS 16 (9640) | Right Ctrl / Menu | |
| Inspiron 14 Plus (7441) | Right Ctrl | Snapdragon X Elite |

### HP

| Model | Key Replaced | Notes |
|-------|-------------|-------|
| EliteBook 840 G11 | Right Ctrl | |
| EliteBook 845 / 855 | Right Ctrl | |
| ProBook G11 | Right Ctrl | |
| OmniBook X | Right Ctrl | Copilot+ PC |
| Victus | Right Ctrl | Turkish Q layout: replaced < > key |
| ZBook Power G11 | Right Ctrl | |

### Lenovo

| Model | Key Replaced | Notes |
|-------|-------------|-------|
| Legion 7 16IRX9 | Right Ctrl | |
| Slim 7x | Right Ctrl | Copilot+ PC |
| Yoga 7 / 7i 2-in-1 | Right Ctrl | |
| ThinkPad 13e | Menu / Context | |

### Acer

| Model | Key Replaced | Notes |
|-------|-------------|-------|
| Predator Helios 18 | Right Ctrl | |
| Nitro V 15 | Right Ctrl | |
| Swift Go 16 (SFG16-72) | Right Ctrl | |

### Samsung

| Model | Key Replaced | Notes |
|-------|-------------|-------|
| Galaxy Book4 Edge | Right of spacebar | |
| Galaxy Book5 series | Right of spacebar | |

### Microsoft

| Model | Key Replaced | Notes |
|-------|-------------|-------|
| Surface Laptop (7th gen) | Right Win / Menu | |

## Is the Copilot Key the Same Across Brands?

**Yes.** Microsoft mandated that the Copilot key sends **LWin + LShift + F23** on all OEMs. Dell has explicitly confirmed this is "standard for the Copilot key and done at Microsoft's direction." There are no known brand-specific variations in the key signal.

This means the fix in this repository should work on **any laptop with a Copilot key**, regardless of brand.

## My Device Isn't Listed

Run `detectar_tecla.ps1` and check if your Copilot key sends the same three events (LWin, LShift, F23). If it does, the fix will work. Please open an issue or PR to add your device to this list.
