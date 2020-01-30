 main:
        leal    4(%esp), %ecx           //инициализация стека
        andl    $-16, %esp              
        pushl   -4(%ecx)
        pushl   %ebp
        movl    %esp, %ebp              //указатель на frame = указатель на стек
        pushl   %ebx
        pushl   %ecx
        subl    $16, %esp               //выделение 16 байт на стеке
        movl    $1, %ebx                //Запись i в ebx
        fldz                            //Обнуление result
        fstpl   -16(%ebp)               //Запись result в стек -16
        jmp     .L4
.L2:
        movl    %ebx, -24(%ebp)         //выполнение else
        fildl   -24(%ebp)
        fstl    -24(%ebp)
        leal    -8(%esp), %esp
        fstpl   (%esp)
        pushl   $-1075838976
        pushl   $0
        call    pow
        fdivl   -24(%ebp)
        faddl   -16(%ebp)               //прибавляем к result
        fstpl   -16(%ebp)
        addl    $16, %esp
.L3:
        addl    $1, %ebx                //увеличение i на 1
        cmpl    $100, %ebx              //сравнение с 100
        je      .L7
.L4:
        testb   $1, %bl                 //сравнения младшего бита с 1
        jne     .L2                     //если нечетное, то L2
        movl    %ebx, -24(%ebp)         //записать i в стеке -24
        fildl   -24(%ebp)		//загрузить i
        fstl    -24(%ebp)               /  
        leal    -8(%esp), %esp          //выделить 8 байт на стеке
        fstpl   (%esp)                  //загрузить i
        pushl   $-1075838976            //добавить x в стек
        pushl   $0                      //
        call    pow                     //выполнить pow(x,i) >> st
        fdivl   -24(%ebp)               //поделить на i
        fsubrl  -16(%ebp)               //вычесть из result
        fstpl   -16(%ebp)               //обновить result
        addl    $16, %esp               //освободить 16 байт
        jmp     .L3
.L7:
        subl    $4, %esp                //вывод result
        pushl   -12(%ebp)
        pushl   -16(%ebp)
        pushl   $_ZSt4cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::basic_ostream<char, std::char_traits<char> >::_M_insert<double>(double)
        addl    $16, %esp               //выход из main
        movl    $0, %eax
        leal    -8(%ebp), %esp
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