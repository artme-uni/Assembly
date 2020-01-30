main:
        leal    4(%esp), %ecx
        pxor    %xmm4, %xmm4            //обнуление xmm4
        pxor    %xmm1, %xmm1            //обнуление xmm1
        andl    $-16, %esp
        pushl   -4(%ecx)
        pushl   %ebp                          
        movl    %esp, %ebp              //указатель на frame = указатель на стек
        pushl   %ebx                    
        movl    $1, %ebx                //запись i в ebx
        pushl   %ecx
        cvtsi2sdl       %ebx, %xmm1     //запись float(i) в xmm1
        subl    $32, %esp               //выделить 32 байта на стеке
        movsd   %xmm4, -16(%ebp)        //запись result в стек -16
        movsd   .LC0, %xmm0             //загрузка x в xmm0
        jmp     .L5
.L8:
        movsd   -16(%ebp), %xmm2        //выполнение части после if
        addl    $1, %ebx                
        subsd   %xmm0, %xmm2            //result - xmm0
        movsd   %xmm2, -16(%ebp)        
        cmpl    $100, %ebx              
        je      .L4
.L9:                                    
        pxor    %xmm1, %xmm1            //обнуление xmm1
        subl    $8, %esp                //выделение 8 байт
        cvtsi2sdl       %ebx, %xmm1     //загрузка (float)i в xmm1
        movsd   %xmm1, (%esp)           //сохранеие i в стек -48
        pushl   $-1075838976            //загрузка x
        pushl   $0                      /
        movsd   %xmm1, -32(%ebp)        //сохранеие i в стек -32
        call    __pow_finite            //pow(x, i) на st
        movsd   -32(%ebp), %xmm1        //i >> xmm1
        addl    $16, %esp               //освобождение 16 байт
        fstpl   -24(%ebp)               //pow(x, i) на стек -24
        movsd   -24(%ebp), %xmm0        //pow(x, i) >> xmm0 
.L5:
        divsd   %xmm1, %xmm0            //(x/i) или в будущем (pow(x,i)/i) >> xmm0
        testb   $1, %bl                 //сравнение младшего бита i c 1 
        je      .L8                     //если четное, то L8
        addsd   -16(%ebp), %xmm0        //result + xmm0
        addl    $1, %ebx                //увеличение i
        movsd   %xmm0, -16(%ebp)        //обновление result
        cmpl    $100, %ebx              //сравнение c n
        jne     .L9                     //если i < 100, то L9
.L4:
        subl    $4, %esp                //вывод result
        pushl   -12(%ebp)
        pushl   -16(%ebp)
        pushl   $_ZSt4cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::basic_ostream<char, std::char_traits<char> >::_M_insert<double>(double)
        addl    $16, %esp
        leal    -8(%ebp), %esp
        xorl    %eax, %eax
        popl    %ecx
        popl    %ebx
        popl    %ebp
        leal    -4(%ecx), %esp
        ret
_GLOBAL__sub_I_main:
        subl    $24, %esp
        pushl   $_ZStL8__ioinit
        call    std::ios_base::Init::Init() [complete object constructor]
        addl    $12, %esp
        pushl   $__dso_handle
        pushl   $_ZStL8__ioinit
        pushl   $_ZNSt8ios_base4InitD1Ev
        call    __cxa_atexit
        addl    $28, %esp
        ret
.LC0:
        .long   0
        .long   -1075838976