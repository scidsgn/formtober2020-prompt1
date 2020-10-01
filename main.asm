    device ZXSPECTRUM128

    org $8000

    include "./lib/output.z80"

    include "./track.asm"
    include "./sky.asm"

Main:
    ; pain incoming
    call PrepScreen
    call PrepTrack
    call PrepSky

    call FillTurnBack
    call DrawString

    call AnimLoop
    ret

AnimTickDelay: db 80 ; delay for tick updates

; Animation loop!
AnimLoop:
    call FillTrackStart

    ; This calms the tick updates by spacing them out
    ld a, (AnimTickDelay)
    cp 0
    jr nz, AnimLoopDone
    ld a, 80
    ld (AnimTickDelay), a

    ; Tick updates
    call TrackPaletteTick

AnimLoopDone:
    ld a, (AnimTickDelay)
    dec a
    ld (AnimTickDelay), a

    jp AnimLoop

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
    ld a, %01000111 ; black, white "ink"
    call Clear_Screen
    call 8859 ; border color
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

; Get sprite address
; BC - XY
; DE - address
; https://www.chibiakumas.com/z80/simplesamples.php#LessonS2
GetScreenPos:
    ld a, c
    and %00111000
    rlca
    rlca
    or b
    ld e, a
    ld a, c
    and %00000111
    ld d, a
    ld a, c
    and %11000000
    rrca
    rrca
    rrca
    or d
    or $40
    ld d, a
    ret

; Moves DE down a line
; https://www.chibiakumas.com/z80/simplesamples.php#LessonS2
GetNextLine:
    inc d
    ld a, d
    and %00000111
    ret nz
    ld a, e
    add a, %00100000
    ld e, a
    ret c
    ld a, d
    sub %00001000
    ld d, a
    ret

; HL - sprite address
; DE - position address
; https://www.chibiakumas.com/z80/simplesamples.php#LessonS2
DrawSprite:
    ld b, 8
SpriteNextLine:
    ld a, (hl)
    ld (de), a
    inc hl

    call GetNextLine
    djnz SpriteNextLine

    ret

    savesna "./main.sna", Main