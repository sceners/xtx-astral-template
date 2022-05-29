
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; ASTRAL 2010 MASM32 IM Dialog Template
; ++Meat code & technics
; http://astral.tuxfamily.org/
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
    include \masm32\include\masm32rt.inc
    include \masm32\include\winmm.inc
    includelib \masm32\lib\winmm.lib
    include sys\ufmod.inc
    includelib sys\ufmod.lib
    include sys\Xbutton.asm
    include data.asm
    include algo.asm
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
AbtProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
TopXY   PROTO :DWORD,:DWORD
Algo    PROTO :DWORD

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

.data?

hInstance   dd ?
Wx          dd ?
Wy          dd ?

.code

start:

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

    fn GetModuleHandle, NULL
    mov hInstance, eax

    call main

    fn ExitProcess, eax

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

main proc

    Dialog "XTX Keygen Template", "Lucida Console", 9,\
            WS_POPUP,\
            5,\
            10, 10, 10, 10,\
            1024

    DlgStatic " ", SS_BITMAP, 0, 0, 1, 1, sBg

    DlgStatic " ", NULL, 5, 5, 100, 10, sProduct
    DlgStatic " ", NULL, 5, 15, 100, 10, sCracker

    DlgEdit ES_AUTOHSCROLL or ES_CENTER or WS_TABSTOP, 30, 130, 150, 10, eName
    DlgEdit ES_AUTOHSCROLL or ES_CENTER or WS_TABSTOP, 30, 160, 150, 10, eSerial

    CallModalDialog hInstance, 0, WndProc, NULL
    ret

main endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

    .IF (uMsg == WM_DESTROY) || (uMsg == WM_CLOSE) || (uMsg == WM_HOTKEY)
@@:     exit

    .ELSEIF (uMsg == WM_INITDIALOG)
        fn BitmapFromResource, hInstance, Bg
        fn SendDlgItemMessage, hWnd, sBg, STM_SETIMAGE, IMAGE_BITMAP, eax

        invoke GetSystemMetrics, SM_CXSCREEN
        invoke TopXY, 480, eax
        mov Wx, eax

        invoke GetSystemMetrics, SM_CYSCREEN
        invoke TopXY, 270, eax
        mov Wy, eax

        fn SetWindowPos, hWnd, 0, Wx, Wy, 480, 270, SWP_NOZORDER

        fn RegisterHotKey, hWnd, NULL, NULL, VK_ESCAPE

        fn XButton, hWnd, 390, 190, DoOff, DoOn, bDo
        fn XButton, hWnd, 430, 200, XOff, XOn, bExit
        fn XButton, hWnd, 400, 223, AbOff, AbOn, bAb

        fn uFMOD_PlaySong, Music, 0, XM_RESOURCE

        fn SetDlgItemText, hWnd, sProduct, ADDR Product
        fn SetDlgItemText, hWnd, sCracker, ADDR Cracker
        fn SetDlgItemText, hWnd, eName, "Enter your name here ..."
        fn SetDlgItemText, hWnd, eSerial, "Your serial will pop here."

    .ELSEIF (uMsg == WM_CTLCOLORSTATIC)
        fn GetDlgCtrlID, lParam
            fn SetTextColor, wParam, 0FFFFFFh
            fn SetBkMode, wParam, TRANSPARENT
            fn GetStockObject, NULL_BRUSH
            ret

    .ELSEIF (uMsg == WM_CTLCOLOREDIT)
        fn GetDlgCtrlID, lParam
            fn SetTextColor, wParam, 0FFFFFFh
            fn SetBkColor, wParam, 0
            fn GetStockObject, BLACK_BRUSH
            ret

    .ELSEIF (uMsg == WM_LBUTTONDOWN)
        fn SendMessage, hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0

    .ELSEIF (uMsg == WM_COMMAND)
        mov eax, wParam

        .IF (ax == bDo)
            fn Algo, hWnd
            fn SetDlgItemText, hWnd, eSerial, eax

        .ELSEIF (ax == bExit)
            jmp @B

        .ELSEIF (ax == bAb)
            call about


        .ENDIF

    .ENDIF

    xor eax, eax
    ret

WndProc endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

TopXY proc wDim:DWORD, sDim:DWORD

    shr sDim, 1      ; divide screen dimension by 2
    shr wDim, 1      ; divide window dimension by 2
    mov eax, wDim    ; copy window dimension into eax
    sub sDim, eax    ; sub half win dimension from half screen dimension

    mov eax, sDim
    ret

TopXY endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

about proc

    Dialog "XTX Keygen Template", "Lucida Console", 9,\
            WS_POPUP,\
            2,\
            10, 10, 10, 10,\
            1024

    DlgStatic " ", SS_BITMAP, 0, 0, 1, 1, sBg
    DlgStatic " ", SS_CENTER, 2, 25, 80, 150, sAbText

    CallModalDialog hInstance, 0, AbtProc, NULL
    ret

about endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

AbtProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

    .IF (uMsg == WM_DESTROY) || (uMsg == WM_CLOSE) || (uMsg == WM_HOTKEY)
@@:     fn DestroyWindow, hWnd

    .ELSEIF (uMsg == WM_INITDIALOG)
        fn BitmapFromResource, hInstance, AbBg
        fn SendDlgItemMessage, hWnd, sBg, STM_SETIMAGE, IMAGE_BITMAP, eax

        invoke GetSystemMetrics, SM_CXSCREEN
        invoke TopXY, 148, eax
        mov Wx, eax

        invoke GetSystemMetrics, SM_CYSCREEN
        invoke TopXY, 270, eax
        mov Wy, eax

        fn SetWindowPos, hWnd, 0, Wx, Wy, 148, 270, SWP_NOZORDER

        fn RegisterHotKey, hWnd, NULL, NULL, VK_ESCAPE

        fn XButton, hWnd, 120, 240, AbXOff, AbXOn, bAbX

        fn SetDlgItemText, hWnd, sAbText, ADDR About

    .ELSEIF (uMsg == WM_LBUTTONDOWN)
        fn SendMessage, hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0

    .ELSEIF (uMsg == WM_CTLCOLORSTATIC)
        fn GetDlgCtrlID, lParam
        fn SetTextColor, wParam, 0FFFFFFh
        fn SetBkMode, wParam, TRANSPARENT
        fn GetStockObject, NULL_BRUSH
        ret

    .ELSEIF (uMsg == WM_COMMAND)
        mov eax, wParam

        .IF (ax == bAbX)
            jmp @B

        .ENDIF

    .ENDIF

    xor eax, eax
    ret

AbtProc endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

end start
