#Requires AutoHotkey v2.0

; ==============================================
;  FIX ASUS: Remapear tecla Copilot a RCtrl
;
;  La tecla Copilot envia LWin+LShift+F23 (~1ms entre eventos).
;  Interceptamos LWin y LShift ANTES de que lleguen al OS.
;  Si F23 aparece dentro de 30ms -> es Copilot -> activar RCtrl.
;  Si no -> son teclas reales -> dejarlas pasar.
; ==============================================

#SingleInstance Force

global state := "idle"
global shiftSuppressed := false

; --- LWin: interceptar y retener ---
$*LWin::{
    global state
    state := "waiting"
    SetTimer(PassKeys, -30)
}

$*LWin up::{
    global state, shiftSuppressed
    if state = "waiting" {
        SetTimer(PassKeys, 0)
        state := "idle"
        if shiftSuppressed {
            shiftSuppressed := false
            SendInput "{LWin down}{LShift down}{LWin up}"
        } else {
            SendInput "{LWin down}{LWin up}"
        }
    } else if state = "lwin_passed" {
        state := "idle"
        SendInput "{LWin up}"
    }
    ; "copilot" o "idle" -> ignorar
}

; --- LShift: interceptar solo si estamos esperando F23 ---
$*LShift::{
    global state, shiftSuppressed
    if state = "waiting" {
        shiftSuppressed := true
    } else {
        shiftSuppressed := false
        SendInput "{LShift down}"
    }
}

$*LShift up::{
    global shiftSuppressed
    if shiftSuppressed {
        shiftSuppressed := false
    } else {
        SendInput "{LShift up}"
    }
}

; --- Timer: si pasan 30ms sin F23, son teclas reales ---
PassKeys() {
    global state, shiftSuppressed
    if state = "waiting" {
        state := "lwin_passed"
        if shiftSuppressed {
            shiftSuppressed := false
            SendInput "{LWin down}{LShift down}"
        } else {
            SendInput "{LWin down}"
        }
    }
}

; --- F23 (SC06E) = Copilot key: activar RCtrl ---
$*SC06E::{
    global state, shiftSuppressed
    SetTimer(PassKeys, 0)
    state := "copilot"
    shiftSuppressed := false
    SendInput "{RCtrl down}"
}

$*SC06E up::{
    global state
    if state = "copilot" {
        state := "idle"
        SendInput "{RCtrl up}"
    }
}
