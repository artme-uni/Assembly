
        //r0...r30 - регистры 64(8 байт) общего назначения, x0...x30 - их алиасы
        //v0...v31 - регистры 128(16 байт) для векторных оп, q0...q31 - их алиасы

//       0
//      -8      d9    
//      -16     d8
//      -24     
//      -32     x19 
//      -40     x30
//      -48     x29 <= sp

//       d9     result
//       x19    i
      

main:
        stp     x29, x30, [sp, -48]! //сохраняем значения x29, x30 по адресу sp-=48
        mov     x29, sp              //копируем адрес sp в x29
        str     x19, [sp, 16]        //сохраняем значение x19 по адресу sp+16

        //инициализация переменных
        mov     x19, 1               //копируем 1 в x19 (i)
        stp     d8, d9, [sp, 32]     //сохраняем значения d8, d9 по адресу sp+32
        movi    d9, #0               //копируем константу 0 в d9 (result)
        b       .L4                  //безусловный переход к if
.L9:
        //векта if + проверка for
        bl      pow                 //переход к pow(x, i) = pow (d0, d1) -> d0

        add     x19, x19, 1         //x19 + 1 -> x19
        fdiv    d0, d0, d8          //d0 / d8 = pow / i -> d0
        cmp     x19, 100            //сравниваем x19 (i) со 100 (n), 
        fsub    d9, d9, d0          //d9 - d0 = result - pow / i
        beq     .L8                 //если i == 100, то завершение (L8)
.L4:
        //проверка условия if
        scvtf   d8, x19             //приводим x19 (i) к float и копируем в d8
        fmov    d0, -5.0e-1         //копируем -0.5 в d0
        fmov    d1, d8              //копируем d8 в d1, теперь d1 = (float)i
        tbz     x19, 0, .L9         //если младший бит равен 0, то L9

        //векта else + проверка for
        bl      pow                 //аналогично ветке if, за исключением sub -> add
        add     x19, x19, 1
        fdiv    d0, d0, d8
        cmp     x19, 100
        fadd    d9, d9, d0          //d9 + d0 = result + pow / i
        bne     .L4                 //если i != 100, то новая итерация (L4), иначе L8
.L8:
        //вывод result
        fmov    d0, d9
        adrp    x0, _ZSt4cout
        add     x0, x0, :lo12:_ZSt4cout
        bl      std::basic_ostream<char, std::char_traits<char> >& std::basic_ostream<char, std::char_traits<char> >::_M_insert<double>(double)

        //return 0
        mov     w0, 0

        //завершение main
        ldr     x19, [sp, 16]
        ldp     d8, d9, [sp, 32]
        ldp     x29, x30, [sp], 48
        ret
_GLOBAL__sub_I_main:
        stp     x29, x30, [sp, -32]!
        mov     x29, sp
        str     x19, [sp, 16]
        adrp    x19, .LANCHOR0
        add     x19, x19, :lo12:.LANCHOR0
        mov     x0, x19
        bl      std::ios_base::Init::Init() [complete object constructor]
        mov     x1, x19
        adrp    x2, __dso_handle
        ldr     x19, [sp, 16]
        adrp    x0, _ZNSt8ios_base4InitD1Ev
        ldp     x29, x30, [sp], 32
        add     x2, x2, :lo12:__dso_handle
        add     x0, x0, :lo12:_ZNSt8ios_base4InitD1Ev
        b       __cxa_atexit