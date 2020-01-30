main:
        pushq   %rbx                    
        pxor    %xmm4, %xmm4            //обнуление xmm4
        movl    $1, %ebx                //инициализация i = 1 
        pxor    %xmm1, %xmm1            //обнуление xmm1
        cvtsi2sdq       %rbx, %xmm1     //загрузка (float)i в xmm1
        subq    $16, %rsp               //выделение 16 байт в стеке
        movq    .LC0(%rip), %rax        //загрузка x в rax
        movsd   %xmm4, (%rsp)           //добавлнение result в стек
        movq    %rax, %xmm0             //x > xmm0
        jmp     .L5
.L8:
        movsd   (%rsp), %xmm2           //выполнение части после if
        addq    $1, %rbx
        subsd   %xmm0, %xmm2            //result - xmm0
        movsd   %xmm2, (%rsp)
        cmpq    $100, %rbx
        je      .L4
.L9:
        pxor    %xmm1, %xmm1            //обнулить xmm1
        movq    .LC0(%rip), %rax        //загрузка x в rax
        cvtsi2sdq       %rbx, %xmm1     //i > xmm1 
        movq    %rax, %xmm0             //x > xmm0            
        movsd   %xmm1, 8(%rsp)          //i в стеке -8
        call    __pow_finite            //вычислить pow(x,i) > xmm0
        movsd   8(%rsp), %xmm1          //i > xmm1
.L5:
        divsd   %xmm1, %xmm0            //(x/i) или в будущем (pow(x,i)/i) >> xmm0
        testb   $1, %bl                 //сравнение младшего бита i c 1 
        je      .L8                     //если четное, то L8
        addsd   (%rsp), %xmm0           //result + xmm0
        addq    $1, %rbx                //увеличить i на 1
        movsd   %xmm0, (%rsp)           //обновить result
        cmpq    $100, %rbx              //сравнение c n
        jne     .L9                     //если i < 100, то L9
.L4:
        movsd   (%rsp), %xmm0           //вывод result
        movl    $_ZSt4cout, %edi
        call    std::basic_ostream<char, std::char_traits<char> >& std::basic_ostream<char, std::char_traits<char> >::_M_insert<double>(double)
        addq    $16, %rsp               //выход из main
        xorl    %eax, %eax
        popq    %rbx
        ret
_GLOBAL__sub_I_main:
        subq    $8, %rsp
        movl    $_ZStL8__ioinit, %edi
        call    std::ios_base::Init::Init() [complete object constructor]
        movl    $__dso_handle, %edx
        movl    $_ZStL8__ioinit, %esi
        movl    $_ZNSt8ios_base4InitD1Ev, %edi
        addq    $8, %rsp
        jmp     __cxa_atexit
.LC0:
        .long   0
        .long   -1075838976