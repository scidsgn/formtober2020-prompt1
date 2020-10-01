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

    ret
