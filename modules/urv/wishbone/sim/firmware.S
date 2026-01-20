.equ LED_ADDR,  0x80000000
.equ TEST_REG, 0x80000100

.section .text
.globl _start

_start:
    li t0, LED_ADDR
    li t1, TEST_REG
    
    # teste de integridade dos dados
    li t2, 0xDEADBEEF       # Valor de teste
    sw t2, 0(t1)            # sw no endereço 0x80000100
    lw t3, 0(t1)            # lw do endereço 0x80000100
    
    # Se t2 == t3, o barramento de dados está OK
    beq t2, t3, blink_loop  
    
error_halt:
    j error_halt            # Trava aqui se a leitura falhou

blink_loop:
    # teste de atuação
    li t4, 1
    sw t4, 0(t0)            # Liga o LED (escreve 1 em 0x80000000)
    call delay
    
    li t4, 0
    sw t4, 0(t0)            # Desliga o LED (escreve 0 em 0x80000000)
    call delay
    
    j blink_loop            # Repete para sempre

# delay
delay:
    li t5, 50         # ajustar conforme o clock
1:
    addi t5, t5, -1
    bnez t5, 1b
    ret