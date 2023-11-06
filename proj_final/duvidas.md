# Dúvidas
1. Segundo as notas:
To initialize the user stack, just set the sp register with the value 0x07FFFFFC.
Eu faço isso com a diretiva .set mesmo? SIM
Esse valor representa o fim ou começo da stack? NAO MUDA NADA SO USA ELE NORMALMENTE

2. Sobre as funções read/write:
Syscall 17 - read-serial
Syscall 18 - write-serial
Elas recebem o tamanho do buffer em a1
read:
    Lê até N caracteres OU até um '\n' ISSO AQUI
    Lê N caracteres independente

write:
    Escreve N caracteres OU até o primeiro '\n'
    Escreve N caracteres independente ISSO AQUI

3. Sobre como identificar as syscalls:
    Daria pra fazer uma LUT (Lookup Table) com o endereço de cada syscall
    pra não ter que ficar fazendo um monte de if?
    Como a primeira syscall tem código 10 poderia subtrair 10, ai o
    endereço na primeira posição é o da syscall 10, o na segunda é o da
    syscall 11, e por ai vai.

    JUMP TABLE
    Salva o ra antes de olhar na lookup table, ja que voce nao vai chamar as funções
    com jal

    tem que multiplicar o acessador por 4, ja que são words, então 1 na real acessa 
    a posição 4 na LUT.

    da pra usar jalr

    jump_table:
        .word case_0
        .word case_1
        .word case_2

4. Sobre a syscall de tempo:
    A syscall retorna o tempo (em ms) desde que o sistema iniciou, então basta
    eu inicializar o GPT, não preciso fazer nada do tipo pedir pra ele gerar
    interrupções, nem armazenar o valor do tempo atual em alguma variável global?

# TODO

- Implementar tratamento de interrupção:
    Lidar com modo de execução
    Stack do usuário e de interrupção
    Salvar valores
- Implementar todas as syscalls:
    [ ] 10
    [ ] 11
    [ ] 12
    [ ] 13
    [ ] 15
    [ ] 16
    [ ] 17
    [ ] 18
    [ ] 20

- Implementar as funções definidas em control-api.h:
