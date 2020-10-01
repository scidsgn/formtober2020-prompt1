; Draws the sky "gradient"
PrepSky:
    ld b, 0
    ld c, 88
    call GetAttrAddress ; HL = address

    ld c, 32 ; width
    ld b, 1 ; height
    ld a, %01001000 ; bright blue
    call Fill_Attr

    ld b, 0
    ld c, 80
    call GetAttrAddress ; HL = address

    ld c, 32 ; width
    ld b, 1 ; height
    ld a, %00001000 ; dark blue
    call Fill_Attr

    call DrawMoon

    ret

; Moon sprites
MoonSprite00: db %00000111
              db %00011111
              db %00111111
              db %01111111
              db %01111111
              db %11111110
              db %11111110
              db %11111110
MoonSprite01: db %11000000
              db %11110000
              db %11111000
              db %11111100
              db %00000100
              db %00000010
              db %00000000
              db %00000000
MoonSprite10: db %11111110
              db %11111110
              db %01111111
              db %01111111
              db %00111111
              db %00011111
              db %00000111
              db %00000000
MoonSprite11: db %00000000
              db %00000010
              db %00000100
              db %11111100
              db %11111000
              db %11110000
              db %11000000
              db %00000000

DrawMoon:
    ld hl, MoonSprite00
    ld b, 2
    ld c, 16
    call GetScreenPos
    call DrawSprite

    ld hl, MoonSprite01
    ld b, 3
    ld c, 16
    call GetScreenPos
    call DrawSprite

    ld hl, MoonSprite10
    ld b, 2
    ld c, 24
    call GetScreenPos
    call DrawSprite

    ld hl, MoonSprite11
    ld b, 3
    ld c, 24
    call GetScreenPos
    call DrawSprite

    ret

StarsSprite0: db %00000000
              db %00000100
              db %00001010
              db %00000100
              db %00000000
              db %01000000
              db %10100000
              db %01000000
StarsSprite1: db %00000000
              db %00001010
              db %00000100
              db %00001010
              db %00000000
              db %10100000
              db %01000000
              db %10100000

StarBlinkOffset: db 0 ; 0 or 1

StarBlinkTick:
    ld a, (StarBlinkOffset)
    xor 1
    ld (StarBlinkOffset), a

DrawStars:
    ld b, 6
    ld c, 16
    call GetScreenPos
    call DrawStar

    ld b, 16
    ld c, 16
    call GetScreenPos
    call DrawStar

    ld b, 26
    ld c, 16
    call GetScreenPos
    call DrawStar

    ld b, 10
    ld c, 32
    call GetScreenPos
    call DrawStar

    ld b, 20
    ld c, 32
    call GetScreenPos
    call DrawStar

    ld b, 30
    ld c, 32
    call GetScreenPos
    call DrawStar

    ld b, 4
    ld c, 48
    call GetScreenPos
    call DrawStar

    ld b, 14
    ld c, 48
    call GetScreenPos
    call DrawStar

    ld b, 24
    ld c, 48
    call GetScreenPos
    call DrawStar

    ret

DrawStar:
    ld hl, StarsSprite0
    ld a, (StarBlinkOffset)
    cp 0
    jr z, DrawStarCont
    ld hl, StarsSprite1
DrawStarCont:
    call DrawSprite
    ret