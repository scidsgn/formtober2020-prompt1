    device ZXSPECTRUM128

    org $8000

    include "./lib/output.z80"

Main:
    ; pain incoming
    call PrepScreen
    call PrepTrack

    call FillTrackStart

    call FillTurnBack
    call DrawString
    ret

; Draws the * TURN BACK * text
TurnBackStr: db $9, $0, "* TURN  BACK *", $FF
DrawString:
    ld ix, TurnBackStr
    call Print_String
    ret

FillTurnBack:
    ld b, 8
    ld c, 0
    call GetAttrAddress ; HL = address

    ld c, 16 ; width
    ld b, 1 ; height
    ld a, %11000010 ; bright red, flashing
    call Fill_Attr
    ret

; fill screen with black
PrepScreen:
    ld a, %00000000 ; black
    call Clear_Screen
    call 8859 ; border color
    ret

; fills out the area that will be next to the track
PrepTrack:
    ld b, 0
    ld c, 96 ; 12 * 8 (8 "pixels" per block)
    call GetAttrAddress

    ld c, 32
    ld b, 12
    ld a, %00111111 ; "dark" white = gray
    call Fill_Attr
    ret

FillTrackStart:
    ld b, 10 ; b is the loop counter
FillTrackLoop:
    push bc ; this puts b (and c) onto the stack
            ; that will preserve the loop counter

    ; Calculating the Y position of the track block
    ld a, b
    rla ; multiply by 8 by rotating left 3 times
    rla
    rla
    add 88
    ld c, a

    ; Calculating the X position of the track block
    ld a, 10
    sub b
    ld b, a

    call GetAttrAddress

    ; Calculating the width
    ; Width = 32 - x - x (x = "margin")
    ld a, 32
    sub b
    sub b
    ld c, a
    ; Height = 1, blah blah...
    ld b, 1
    ld a, %01010010
    call Fill_Attr

    pop bc ; bring back the loop counter
    djnz FillTrackLoop ; loop back if b != 0

    ret

; Get address of block in attribute map
; BC - XY
; address -> HL
; https://www.chibiakumas.com/z80/simplesamples.php#LessonS2
GetAttrAddress:
    ld a, C
        and %11000000
        rlca
        rlca
        add $58
        ld d, a
    ld a, C
    and %00111000
    rlca
    rlca

    add b
    ld e, a

    push de
    pop hl
    ret

    savesna "./main.sna", Main