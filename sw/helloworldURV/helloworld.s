.section .text
.global _start

_start:
    li t0, 0x80000000    # Endereço externo (ativa o bit 31)
    li t1, 0x12345678    # Valor qualquer para escrita
    li t3, 10000000            # Delay
loop_principal:
    # --- LIGA O LED (Acesso ao barramento) ---
    sw t1, 0(t0)         # O sinal .stb vai para 1 aqui
    
    # --- DELAY (Mantém o estado) ---
    mv t2, t3            # Carrega o contador
delay1:
    addi t2, t2, -1      # Subtrai 1
    bnez t2, delay1      # Enquanto não for zero, continua no delay

    # --- DESLIGA O LED  ---
    li t4, 0x00001000    # Endereço da RAM interna (bit 31 em '0')
    sw t1, 0(t4)         # O sinal .stb volta para 0 aqui

    # --- DELAY ---
    mv t2, t3
delay2:
    addi t2, t2, -1
    bnez t2, delay2

    j loop_principal     # Reinicia o ciclo


# comandos para o .mem no terminal do ubuntu (não precisa fazer caso o .mem já esteja na pasta e não haja alterações)
# riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 -o helloworld.o helloworld.s
# riscv64-unknown-elf-ld -m elf32lriscv -Ttext 0 -o helloworld.elf helloworld.o
# riscv64-unknown-elf-objcopy -O binary helloworld.elf helloworld.bin
# hexdump -v -e '1/4 "%08x" "\n"' helloworld.bin > firmware.mem


  