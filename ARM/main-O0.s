        
        //r0...r30 - регистры 64(8 байт) общего назначения, x0...x30 - их алиасы
        //v0...v31 - регистры 128(16 байт) для векторных оп, q0...q31 - их алиасы

//       0
//      -8       0   - result = 0  
//      -16     x0   - i = 1...n
//      -24     d0   - x = -0.5
//      -32     x0   - n = 100
//      -40     x30
//      -48     x29 <= sp

main:
        stp     x29, x30, [sp, -48]!    //сохраняем значения x29, x30 по адресу sp-=48
        mov     x29, sp                 //копируем адрес sp в x29

        //инициализация переменных
        fmov    d0, -5.0e-1             //копируем -0.5 в d0
        str     d0, [sp, 24]            //сохраняем значения d0 в sp+24
        mov     x0, 100                 //копируем 100 в x0
        str     x0, [sp, 16]            //сохраняем значения x0 в sp+16
        str     xzr, [sp, 40]           //сохраняем 0 в sp+40
        mov     x0, 1                   //копируем 1 в x0
        str     x0, [sp, 32]            //сохраняем значения x0 в sp+32
.L5:
        //проверка условия for
        ldr     x1, [sp, 32]            //загрузить значение из sp+32 (i) в x1
        ldr     x0, [sp, 16]            //загрузить значение из sp+16 (n) в 
        cmp     x1, x0                  //сравнить n с i, перейти к L2, если 
        bge     .L2                     //n >= i (branch if greater or equal)

        //проверка на кратность
        ldr     x0, [sp, 32]            //загрузить значения из sp+32 (i) в x0
        and     x0, x0, 1               //берем младший бит
        cmp     x0, 0                   //сравниваем его с нулём
        bne     .L3                     //если не равны, то ветка else

        //ветка if
        ldr     x0, [sp, 32]            //загрузить значения из sp+32 (i) в x0
        scvtf   d0, x0                  //приводим x0 (i) к float и копируем в d0
        fmov    d1, d0                  //копируем d0 в d1, теперь d1 = (float)i
        ldr     d0, [sp, 24]            //загрузить значение из sp+24 (x) в d0
        bl      pow                     //переход к pow(x, i) = pow (d0, d1) -> d0

        fmov    d1, d0                  //копируем d0 (pow) в d1
        ldr     x0, [sp, 32]            //загрузить значения из sp+32 (i) в x0
        scvtf   d0, x0                  //приводим x0 (i) к float и копируем в d0
        fdiv    d0, d1, d0              //d1 / d0 = pow / i -> d0
        ldr     d1, [sp, 40]            //загрузить значения из sp+40 (result) в d1
        fsub    d0, d1, d0              //d1 - d0 = pow / i - result -> d0
        str     d0, [sp, 40]            //сохраняем значения d0 в sp+40 (result)
        b       .L4                     //безусловный переход к постуловию for
.L3:
        //ветка else
        ldr     x0, [sp, 32]            //аналогично ветке if, за исключением sub -> add
        scvtf   d0, x0
        fmov    d1, d0
        ldr     d0, [sp, 24]
        bl      pow
        fmov    d1, d0
        ldr     x0, [sp, 32]
        scvtf   d0, x0
        fdiv    d0, d1, d0
        ldr     d1, [sp, 40]
        fadd    d0, d1, d0              //d1 - d0 = pow / i - result -> d0
        str     d0, [sp, 40]
.L4:
        //увеличение значений в for
        ldr     x0, [sp, 32]            //загрузить значения из sp+32 (i) в x0
        add     x0, x0, 1               //x0 + 1 = i++ -> x0
        str     x0, [sp, 32]            //сохраняем значения x0 в sp+32 (i)
        b       .L5                     //безусловный переход в проверку for
.L2:
        //вывод значения по адресу sp+40 (result)
        ldr     d0, [sp, 40]
        adrp    x0, _ZSt4cout
        add     x0, x0, :lo12:_ZSt4cout
        bl      std::basic_ostream<char, std::char_traits<char> >::operator<<(double)

        //return 0
        mov     w0, 0

        //завершение main
        ldp     x29, x30, [sp], 48
        ret
__static_initialization_and_destruction_0(int, int):
        stp     x29, x30, [sp, -32]!
        mov     x29, sp
        str     w0, [sp, 28]
        str     w1, [sp, 24]
        ldr     w0, [sp, 28]
        cmp     w0, 1
        bne     .L9
        ldr     w1, [sp, 24]
        mov     w0, 65535
        cmp     w1, w0
        bne     .L9
        adrp    x0, _ZStL8__ioinit
        add     x0, x0, :lo12:_ZStL8__ioinit
        bl      std::ios_base::Init::Init() [complete object constructor]
        adrp    x0, __dso_handle
        add     x2, x0, :lo12:__dso_handle
        adrp    x0, _ZStL8__ioinit
        add     x1, x0, :lo12:_ZStL8__ioinit
        adrp    x0, _ZNSt8ios_base4InitD1Ev
        add     x0, x0, :lo12:_ZNSt8ios_base4InitD1Ev
        bl      __cxa_atexit
.L9:
        nop
        ldp     x29, x30, [sp], 32
        ret
_GLOBAL__sub_I_main:
        stp     x29, x30, [sp, -16]!
        mov     x29, sp
        mov     w1, 65535
        mov     w0, 1
        bl      __static_initialization_and_destruction_0(int, int)
        ldp     x29, x30, [sp], 16
        ret