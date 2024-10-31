algoritmo "Sistema de Reservas de Hotel"

// Estruturas para armazenamento de dados dos quartos, reservas e clientes

variáveis
    tipo Quarto
        numero : inteiro
        tipo : caractere // "Simples", "Luxo" ou "Executivo"
        precoDiaria : real
        disponivel : logico
    fimTipo

    tipo Cliente
        nome : caractere
        cpf : caractere
    fimTipo

    tipo Reserva
        cliente : Cliente
        quarto : Quarto
        diasReservados : inteiro
        totalPagar : real
        status : caractere // "Reservado", "Check-in", "Check-out"
    fimTipo

    quartos : vetor[1..50] de Quarto
    reservas : vetor[1..100] de Reserva

    totalQuartos, totalReservas : inteiro
    opcao : inteiro
    nomeCliente, cpfCliente : caractere
    numeroQuarto, dias : inteiro

início
    totalQuartos ← 0
    totalReservas ← 0

    // Função para adicionar quartos ao hotel
    funcao adicionarQuarto()
        totalQuartos ← totalQuartos + 1
        escreva("Número do Quarto: ")
        leia(quartos[totalQuartos].numero)
        escreva("Tipo de Quarto (Simples/Luxo/Executivo): ")
        leia(quartos[totalQuartos].tipo)
        
        escolha quartos[totalQuartos].tipo
            caso "Simples"
                quartos[totalQuartos].precoDiaria ← 100.0
            caso "Luxo"
                quartos[totalQuartos].precoDiaria ← 200.0
            caso "Executivo"
                quartos[totalQuartos].precoDiaria ← 300.0
            caso contrário
                escreva("Tipo inválido, configurando para Simples.\n")
                quartos[totalQuartos].precoDiaria ← 100.0
        fimescolha

        quartos[totalQuartos].disponivel ← verdadeiro
        escreva("Quarto adicionado com sucesso!\n")
    fimfuncao

    // Função para verificar disponibilidade de quartos
    funcao verificarDisponibilidade()
        escreva("Quartos Disponíveis:\n")
        para i de 1 até totalQuartos faça
            se quartos[i].disponivel entao
                escreva("Quarto ", quartos[i].numero, " - Tipo: ", quartos[i].tipo, " - Diária: R$", quartos[i].precoDiaria, "\n")
            fimse
        fimpara
    fimfuncao

    // Função para calcular tarifa com possível desconto
    funcao calcularTarifa(precoDiaria : real, dias : inteiro) : real
        var total : real
        total ← precoDiaria * dias

        se dias >= 7 entao
            total ← total * 0.9 // Aplica 10% de desconto para estadias de 7 dias ou mais
        fimse
        
        retorne total
    fimfuncao

    // Função para fazer uma reserva
    funcao fazerReserva()
        escreva("Nome do Cliente: ")
        leia(nomeCliente)
        escreva("CPF do Cliente: ")
        leia(cpfCliente)

        escreva("Número do Quarto para reservar: ")
        leia(numeroQuarto)
        escreva("Quantidade de dias: ")
        leia(dias)

        para i de 1 até totalQuartos faça
            se quartos[i].numero = numeroQuarto e quartos[i].disponivel entao
                totalReservas ← totalReservas + 1
                reservas[totalReservas].cliente.nome ← nomeCliente
                reservas[totalReservas].cliente.cpf ← cpfCliente
                reservas[totalReservas].quarto ← quartos[i]
                reservas[totalReservas].diasReservados ← dias
                reservas[totalReservas].totalPagar ← calcularTarifa(quartos[i].precoDiaria, dias)
                reservas[totalReservas].status ← "Reservado"
                
                quartos[i].disponivel ← falso
                escreva("Reserva realizada com sucesso! Total a pagar: R$", reservas[totalReservas].totalPagar, "\n")
                pare
            fimse
        fimpara
    fimfuncao

    // Função para realizar check-in
    funcao realizarCheckIn()
        escreva("Digite o CPF do cliente para check-in: ")
        leia(cpfCliente)

        para i de 1 até totalReservas faça
            se reservas[i].cliente.cpf = cpfCliente e reservas[i].status = "Reservado" entao
                reservas[i].status ← "Check-in"
                escreva("Check-in realizado para o cliente ", reservas[i].cliente.nome, " no quarto ", reservas[i].quarto.numero, "\n")
                retorne
            fimse
        fimpara
        escreva("Reserva não encontrada ou já foi feito o check-in.\n")
    fimfuncao

    // Função para realizar check-out
    funcao realizarCheckOut()
        escreva("Digite o CPF do cliente para check-out: ")
        leia(cpfCliente)

        para i de 1 até totalReservas faça
            se reservas[i].cliente.cpf = cpfCliente e reservas[i].status = "Check-in" entao
                reservas[i].status ← "Check-out"
                reservas[i].quarto.disponivel ← verdadeiro
                escreva("Check-out realizado para o cliente ", reservas[i].cliente.nome, " no quarto ", reservas[i].quarto.numero, "\n")
                retorne
            fimse
        fimpara
        escreva("Check-in não encontrado para o CPF fornecido.\n")
    fimfuncao

    // Função para gerar relatório de ocupação
    funcao gerarRelatorioOcupacao()
        escreva("=== Relatório de Ocupação ===\n")
        para i de 1 até totalReservas faça
            escreva("Cliente: ", reservas[i].cliente.nome, " | Quarto: ", reservas[i].quarto.numero, " | Status: ", reservas[i].status, " | Total a Pagar: R$", reservas[i].totalPagar, "\n")
        fimpara
    fimfuncao

    // Menu Principal
    repita
        escreva("\n=== Sistema de Reservas de Hotel ===\n")
        escreva("1. Adicionar Quarto\n")
        escreva("2. Verificar Disponibilidade\n")
        escreva("3. Fazer Reserva\n")
        escreva("4. Realizar Check-in\n")
        escreva("5. Realizar Check-out\n")
        escreva("6. Gerar Relatório de Ocupação\n")
        escreva("0. Sair\n")
        escreva("Escolha uma opção: ")
        leia(opcao)

        escolha opcao
            caso 1
                adicionarQuarto()
            caso 2
                verificarDisponibilidade()
            caso 3
                fazerReserva()
            caso 4
                realizarCheckIn()
            caso 5
                realizarCheckOut()
            caso 6
                gerarRelatorioOcupacao()
            caso 0
                escreva("Saindo do sistema de reservas...\n")
            caso contrário
                escreva("Opção inválida.\n")
        fimescolha
    até opcao = 0

fimalgoritmo
