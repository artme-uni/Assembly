main:
        pushq   %rbx                    
        subq    $16, %rsp               //Выделение 16 байт на стеке 
        movl    $1, %ebx                //Инициализация i = 1
        pxor    %xmm6, %xmm6            //Обнуление result
        movsd   %xmm6, (%rsp)           //Запись в стек
        jmp     .L4
.L2:
        pxor    %xmm4, %xmm4            //выполнение else
        cvtsi2sdq       %rbx, %xmm4
        movsd   %xmm4, 8(%rsp)
        movapd  %xmm4, %xmm1
        movsd   .LC1(%rip), %xmm0
        call    pow
        divsd   8(%rsp), %xmm0
        addsd   (%rsp), %xmm0           //прибавляем к result
        movsd   %xmm0, (%rsp)
.L3:
        addq    $1, %rbx                //увеличение i на 1
        cmpq    $100, %rbx              //сравнение с 100
        je      .L7
.L4:
        testb   $1, %bl                 //сравнения младшего бита с 1
        jne     .L2                     //если нечетное, то L2
        pxor    %xmm2, %xmm2            //обнуление xmm2
        cvtsi2sdq       %rbx, %xmm2     //Загрузка (float)i в xmm2
        movsd   %xmm2, 8(%rsp)          //загрузка i в -8
        movapd  %xmm2, %xmm1            //i > xmm1
        movsd   .LC1(%rip), %xmm0       //загрузка x в xmm0
        call    pow                     //pow(xmm0, xmm1) > xmm0
        divsd   8(%rsp), %xmm0          //деление xmm0 на i
        movsd   (%rsp), %xmm3           //загружаем result в xmm3
        subsd   %xmm0, %xmm3            //вычитаем из result
        movsd   %xmm3, (%rsp)           //сохранение результата
        jmp     .L3
.L7:
        movsd   (%rsp), %xmm0           //вывод result
        movl    $_ZSt4cout, %edi
        call    std::basic_ostream<char, std::char_traits<char> >& std::basic_ostream<char, std::char_traits<char> >::_M_insert<double>(double)
        movl    $0, %eax                //выход из main
        addq    $16, %rsp
        popq    %rbx
        ret
_GLOBAL__sub_I_main:
        subq    $8, %rsp
        movl    $_ZStL8__ioinit, %edi
        call    std::ios_base::Init::Init() [complete object constructor]
        movl    $__dso_handle, %edx
        movl    $_ZStL8__ioinit, %esi
        movl    $_ZNSt8ios_base4InitD1Ev, %edi
        call    __cxa_atexit
        addq    $8, %rsp
        ret
.LC1:
        .long   0
        .long   -1075838976