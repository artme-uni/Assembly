main:
        pushq   %rbp                            
        movq    %rsp, %rbp                      //указатель на frame = указатель на стек
        subq    $32, %rsp                       //выделение 32 байт на стеке
        movsd   .LC0(%rip), %xmm0               //загрузка x в блок xmm
        movsd   %xmm0, -24(%rbp)                //запись x в стек со сдвигом -24
        movq    $100, -32(%rbp)                 //запись n в стек со сдвигом -32
        pxor    %xmm0, %xmm0                    //обнуление xmm0        
        movsd   %xmm0, -8(%rbp)                 //обнуление result и запись в стек -8
        movq    $1, -16(%rbp)                   //запись i в стек со сдвигом -16
.L5:
        movq    -16(%rbp), %rax                 //проверка условий for
        cmpq    -32(%rbp), %rax                 //
        jge     .L2                             //если i >= n прыгаем на L2
        movq    -16(%rbp), %rax                 //загрузка i
        andl    $1, %eax                        //взятие младшего бита
        testq   %rax, %rax                      //сравнение с 0
        jne     .L3                             //если нечетное(!=0), то L3
        cvtsi2sdq       -16(%rbp), %xmm0        //загрузка (float)i в xmm0
        movq    -24(%rbp), %rax                 //загрузка x в rax
        movapd  %xmm0, %xmm1                    // i > xmm1     
        movq    %rax, %xmm0                     // x > xmm0
        call    pow                             //pow (x, i) > xmm0
        cvtsi2sdq       -16(%rbp), %xmm1        //загрузка (float)i в xmm1
        divsd   %xmm1, %xmm0                    //вычисление (pow / i)  
        movapd  %xmm0, %xmm1                    //кладем в xmm1
        movsd   -8(%rbp), %xmm0                 //загружаем result в xmm0
        subsd   %xmm1, %xmm0                    //result - (pow / i)
        movsd   %xmm0, -8(%rbp)                 //обновление result
        jmp     .L4
.L3:
        cvtsi2sdq       -16(%rbp), %xmm0        //Выполнение else
        movq    -24(%rbp), %rax
        movapd  %xmm0, %xmm1
        movq    %rax, %xmm0
        call    pow
        cvtsi2sdq       -16(%rbp), %xmm1
        divsd   %xmm1, %xmm0
        movsd   -8(%rbp), %xmm1
        addsd   %xmm1, %xmm0                    //прибавляем промежуточное значение
        movsd   %xmm0, -8(%rbp)
.L4:  
        addq    $1, -16(%rbp)                   //увеличение i на 1
        jmp     .L5
.L2:
        movq    -8(%rbp), %rax                  //вывод result
        movq    %rax, %xmm0
        movl    $_ZSt4cout, %edi
        call    std::basic_ostream<char, std::char_traits<char> >::operator<<(double)
        movl    $0, %eax                        //выход из main
        leave
        ret
__static_initialization_and_destruction_0(int, int):
        pushq   %rbp
        movq    %rsp, %rbp
        subq    $16, %rsp
        movl    %edi, -4(%rbp)
        movl    %esi, -8(%rbp)
        cmpl    $1, -4(%rbp)
        jne     .L9
        cmpl    $65535, -8(%rbp)
        jne     .L9
        movl    $_ZStL8__ioinit, %edi
        call    std::ios_base::Init::Init() [complete object constructor]
        movl    $__dso_handle, %edx
        movl    $_ZStL8__ioinit, %esi
        movl    $_ZNSt8ios_base4InitD1Ev, %edi
        call    __cxa_atexit
.L9:
        nop
        leave
        ret
_GLOBAL__sub_I_main:
        pushq   %rbp
        movq    %rsp, %rbp
        movl    $65535, %esi
        movl    $1, %edi
        call    __static_initialization_and_destruction_0(int, int)
        popq    %rbp
        ret
.LC0:
        .long   0
        .long   -1075838976