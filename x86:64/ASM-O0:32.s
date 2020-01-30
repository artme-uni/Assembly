main:
        leal    4(%esp), %ecx           //инициализация стека
        andl    $-16, %esp             
        pushl   -4(%ecx)                
        pushl   %ebp
        movl    %esp, %ebp              //указатель на frame = указатель на стек
        pushl   %ecx                    
        subl    $36, %esp               //выделить 36 байт под локальные данные
        fldl    .LC0                    //загрузить вещественное значение x
        fstpl   -32(%ebp)               //сохранить x в стек со сдвигом -32
        movl    $100, -36(%ebp)         //запись n в стек со сдвигом -36
        fldz                            
        fstpl   -16(%ebp)               //обнуление result и запись в стек -16
        movl    $1, -20(%ebp)           //запись i в стек со сдвигом -20
.L5:
        movl    -20(%ebp), %eax         //проверка условий for
        cmpl    -36(%ebp), %eax         
        jge     .L2                     //если i >= n прыгаем на L2
        movl    -20(%ebp), %eax         
        andl    $1, %eax                //взятие младшего бита
        testl   %eax, %eax              //сравнение на ноль
        jne     .L3                     //если нечетное(!=0), то L3
        fildl   -20(%ebp)               //загружаем i в st(0)
        leal    -8(%esp), %esp          //выделяем 8 байт
        fstpl   (%esp)                  //берем i из st и кладём на вершину стека
        pushl   -28(%ebp)               //первая часть x в стек
        pushl   -32(%ebp)               //вторая часть x в стек
        call    pow                     //результат в st
        addl    $16, %esp               //освобождение 16 байт в стеке
        fildl   -20(%ebp)               //загрузка значения i в st
        fdivrp  %st, %st(1)             //вычисление pow / i >> st(0)
        fldl    -16(%ebp)               //загрузка result
        fsubp   %st, %st(1)             //result - (pow / i)
        fstpl   -16(%ebp)               //обновляем result
        jmp     .L4
.L3:
        fildl   -20(%ebp)               //Выполнение else
        leal    -8(%esp), %esp
        fstpl   (%esp)
        pushl   -28(%ebp)
        pushl   -32(%ebp)
        call    pow
        addl    $16, %esp
        fildl   -20(%ebp)
        fdivrp  %st, %st(1)
        fldl    -16(%ebp)
        faddp   %st, %st(1)             //прибавляем промежуточное значение
        fstpl   -16(%ebp)
.L4:
        addl    $1, -20(%ebp)           //увеличение i на 1
        jmp     .L5
.L2:
        subl    $4, %esp                //вывод result
        pushl   -12(%ebp)
        pushl   -16(%ebp)
        pushl   $_ZSt4cout
        call    std::basic_ostream<char, std::char_traits<char> >::operator<<(double)
        addl    $16, %esp               //выход из main
        movl    $0, %eax
        movl    -4(%ebp), %ecx
        leave
        leal    -4(%ecx), %esp
        ret
__static_initialization_and_destruction_0(int, int):
        pushl   %ebp
        movl    %esp, %ebp
        subl    $8, %esp
        cmpl    $1, 8(%ebp)
        jne     .L9
        cmpl    $65535, 12(%ebp)
        jne     .L9
        subl    $12, %esp
        pushl   $_ZStL8__ioinit
        call    std::ios_base::Init::Init() [complete object constructor]
        addl    $16, %esp
        subl    $4, %esp
        pushl   $__dso_handle
        pushl   $_ZStL8__ioinit
        pushl   $_ZNSt8ios_base4InitD1Ev
        call    __cxa_atexit
        addl    $16, %esp
.L9:
        nop
        leave
        ret
_GLOBAL__sub_I_main:
        pushl   %ebp
        movl    %esp, %ebp
        subl    $8, %esp
        subl    $8, %esp
        pushl   $65535
        pushl   $1
        call    __static_initialization_and_destruction_0(int, int)
        addl    $16, %esp
        leave
        ret
.LC0:
        .long   0
        .long   -1075838976