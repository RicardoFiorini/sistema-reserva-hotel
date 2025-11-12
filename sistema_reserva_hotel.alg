algoritmo "Sistema de Reservas de Hotel Aprimorado"

// --- Constantes de Limite ---
const
   LIMITE_QUARTOS = 50
   LIMITE_RESERVAS = 100

// --- Definição dos Tipos (Registros) ---
tipo Quarto
   numero: inteiro
   tipo: caractere // "Simples", "Luxo" ou "Executivo"
   precoDiaria: real
   disponivel: logico
fimTipo

tipo Cliente
   nome: caractere
   cpf: caractere
fimTipo

// --- OTIMIZAÇÃO: A reserva armazena o ÍNDICE do quarto ---
tipo Reserva
   cliente: Cliente
   indiceQuarto: inteiro // O índice (posição) do quarto no vetor 'quartos'
   diasReservados: inteiro
   totalPagar: real
   status: caractere // "Reservado", "Check-in", "Check-out"
fimTipo

// --- Variáveis Globais ---
var
   quartos: vetor[1..LIMITE_QUARTOS] de Quarto
   reservas: vetor[1..LIMITE_RESERVAS] de Reserva
   totalQuartos, totalReservas: inteiro
   opcao: inteiro

// --- Procedimento: Pausa a execução ---
procedimento Pausar()
var
   tecla: caractere
inicio
   escreva("\n(Pressione [ENTER] para voltar ao menu...)")
   leia(tecla)
fimprocedimento

// --- Função: Busca um quarto pelo NÚMERO ---
// (Retorna o ÍNDICE [1..50] do quarto ou 0 se não encontrar)
funcao buscarQuartoPorNumero(numero: inteiro) : inteiro
var
   i: inteiro
inicio
   para i de 1 até totalQuartos faca
      se (quartos[i].numero = numero) entao
         retorne i // Encontrou! Retorna o índice (posição)
      fimse
   fimpara
   retorne 0 // Não encontrou
fimfuncao

// --- Função: Busca uma reserva ATIVA (Reservado ou Check-in) pelo CPF ---
// (Retorna o ÍNDICE [1..100] da reserva ou 0 se não encontrar)
funcao buscarReservaAtivaPorCPF(cpfBusca: caractere; statusBusca: caractere) : inteiro
var
   i: inteiro
inicio
   para i de 1 até totalReservas faca
      // Procura um CPF E um status específico (ex: "Reservado" ou "Check-in")
      se (reservas[i].cliente.cpf = cpfBusca) e (reservas[i].status = statusBusca) entao
         retorne i // Encontrou!
      fimse
   fimpara
   retorne 0 // Não encontrou
fimfuncao


// --- Procedimento: Adicionar Quarto (com validação) ---
procedimento adicionarQuarto()
var
   numQuarto, opcaoTipo: inteiro
   tipoQuarto: caractere
   preco: real
inicio
   limpatela
   escreva("--- Adicionar Quarto ao Hotel ---\n")
   
   
   se (totalQuartos >= LIMITE_QUARTOS) entao
      escreva("[ERRO] Limite de (", LIMITE_QUARTOS, ") quartos atingido!\n")
      retorne
   fimse

   escreva("Número do Quarto (ex: 101, 202): ")
   leia(numQuarto)

   // 1. Validação de Duplicidade
   se (buscarQuartoPorNumero(numQuarto) > 0) entao
      escreva("\n[ERRO] Já existe um quarto com este número!\n")
   senao
      // 2. Validação do Tipo (Menu numérico)
      opcaoTipo <- 0
      enquanto (opcaoTipo < 1) ou (opcaoTipo > 3) faca
         escreva("Escolha o tipo de Quarto:\n")
         escreva("1. Simples (R$ 100.00)\n")
         escreva("2. Luxo (R$ 200.00)\n")
         escreva("3. Executivo (R$ 300.00)\n")
         escreva("Opção: ")
         leia(opcaoTipo)
      fimenquanto
      
      escolha opcaoTipo
         caso 1
            tipoQuarto <- "Simples"
            preco <- 100.0
         caso 2
            tipoQuarto <- "Luxo"
            preco <- 200.0
         caso 3
            tipoQuarto <- "Executivo"
            preco <- 300.0
      fimescolha

      // 3. Adiciona o quarto
      totalQuartos <- totalQuartos + 1
      quartos[totalQuartos].numero <- numQuarto
      quartos[totalQuartos].tipo <- tipoQuarto
      quartos[totalQuartos].precoDiaria <- preco
      quartos[totalQuartos].disponivel <- verdadeiro
      
      escreva("\nQuarto ", numQuarto, " (", tipoQuarto, ") adicionado com sucesso!\n")
   fimse
fimprocedimento

// --- Procedimento: Verificar Disponibilidade ---
procedimento verificarDisponibilidade()
var
   i: inteiro
   disponiveis: inteiro
inicio
   limpatela
   escreva("=============================================================\n")
   escreva("=                  QUARTOS DISPONÍVEIS                  =\n")
   escreva("=============================================================\n")
   disponiveis <- 0
   
   para i de 1 até totalQuartos faca
      se (quartos[i].disponivel) entao
         escreval("  Quarto: ", quartos[i].numero:3, " | Tipo: ", quartos[i].tipo:10, " | Diária: R$", quartos[i].precoDiaria:7:2)
         disponiveis <- disponiveis + 1
      fimse
   fimpara
   
   se (disponiveis = 0) entao
      escreva("  (Nenhum quarto disponível no momento)\n")
   fimse
   escreva("=============================================================\n")
fimprocedimento

// --- Função: Calcular Tarifa (com desconto) ---
// (Estava correta e foi mantida)
funcao calcularTarifa(precoDiaria: real; dias: inteiro) : real
var
   total: real
inicio
   total <- precoDiaria * dias

   se (dias >= 7) entao
      total <- total * 0.9 // Aplica 10% de desconto
   fimse
   
   retorne total
fimfuncao

// --- Procedimento: Fazer Reserva (com validação) ---
procedimento fazerReserva()
var
   nomeCliente, cpfCliente: caractere
   numeroQuarto, dias, indiceQuarto: inteiro
inicio
   limpatela
   escreva("--- Fazer Nova Reserva ---\n")
   
   // Mostra os quartos disponíveis para o cliente
   verificarDisponibilidade()
   
   escreva("Digite o Número do Quarto para reservar: ")
   leia(numeroQuarto)
   
   indiceQuarto <- buscarQuartoPorNumero(numeroQuarto)
   
   // 1. Validação do Quarto
   se (indiceQuarto = 0) entao
      escreva("\n[ERRO] Quarto não encontrado.\n")
   senao se (quartos[indiceQuarto].disponivel = falso) entao
      escreva("\n[ERRO] O quarto ", numeroQuarto, " não está disponível.\n")
   senao
      // 2. Validação de Limite de Reservas
      se (totalReservas >= LIMITE_RESERVAS) entao
         escreva("\n[ERRO] Sistema de reservas está lotado!\n")
         retorne
      fimse
   
      // 3. Coleta de Dados
      escreva("Nome do Cliente: ")
      leia(nomeCliente)
      escreva("CPF do Cliente: ")
      leia(cpfCliente)
      
      dias <- 0
      enquanto (dias <= 0) faca
         escreva("Quantidade de dias: ")
         leia(dias)
         se (dias <= 0) entao
            escreva("[ERRO] O número de dias deve ser positivo.\n")
         fimse
      fimenquanto

      // 4. Cria a Reserva
      totalReservas <- totalReservas + 1
      reservas[totalReservas].cliente.nome <- nomeCliente
      reservas[totalReservas].cliente.cpf <- cpfCliente
      reservas[totalReservas].indiceQuarto <- indiceQuarto // Armazena o ÍNDICE
      reservas[totalReservas].diasReservados <- dias
      reservas[totalReservas].status <- "Reservado"
      reservas[totalReservas].totalPagar <- calcularTarifa(quartos[indiceQuarto].precoDiaria, dias)
      
      // 5. Marca o quarto original como indisponível
      quartos[indiceQuarto].disponivel <- falso
      
      escreva("\nReserva realizada com sucesso para ", nomeCliente, "!\n")
      escreva("Quarto: ", quartos[indiceQuarto].numero, " (", quartos[indiceQuarto].tipo, ")\n")
      escreva("Total a pagar (com ", dias, " dias): R$", reservas[totalReservas].totalPagar:0:2, "\n")
   fimse
fimprocedimento

// --- Procedimento: Realizar Check-in ---
procedimento realizarCheckIn()
var
   cpfCliente: caractere
   indiceReserva, indiceQuarto: inteiro
inicio
   limpatela
   escreva("--- Realizar Check-in ---\n")
   

   escreva("Digite o CPF do cliente para check-in: ")
   leia(cpfCliente)
   
   // Procura uma reserva "Reservado" com este CPF
   indiceReserva <- buscarReservaAtivaPorCPF(cpfCliente, "Reservado")
   
   se (indiceReserva = 0) entao
      escreva("\n[ERRO] Nenhuma reserva 'Reservada' encontrada para este CPF.\n")
   senao
      // Atualiza o status
      reservas[indiceReserva].status <- "Check-in"
      
      // Apenas para exibição
      indiceQuarto <- reservas[indiceReserva].indiceQuarto 
      
      escreva("\nCheck-in realizado com sucesso!\n")
      escreva("Cliente: ", reservas[indiceReserva].cliente.nome, "\n")
      escreva("Quarto: ", quartos[indiceQuarto].numero, "\n")
   fimse
fimprocedimento

// --- Procedimento: Realizar Check-out (COM CORREÇÃO CRÍTICA) ---
procedimento realizarCheckOut()
var
   cpfCliente: caractere
   indiceReserva, indiceQuarto, numQuarto: inteiro
inicio
   limpatela
   escreva("--- Realizar Check-out ---\n")
   
   escreva("Digite o CPF do cliente para check-out: ")
   leia(cpfCliente)
   
   // Procura uma reserva "Check-in" com este CPF
   indiceReserva <- buscarReservaAtivaPorCPF(cpfCliente, "Check-in")
   
   se (indiceReserva = 0) entao
      escreva("\n[ERRO] Nenhum 'Check-in' ativo encontrado para este CPF.\n")
   senao
      // 1. Atualiza o status da reserva
      reservas[indiceReserva].status <- "Check-out"
      
      // --- A CORREÇÃO CRÍTICA ESTÁ AQUI ---
      
      // 2. Pega o ÍNDICE do quarto que estava na reserva
      indiceQuarto <- reservas[indiceReserva].indiceQuarto
      
      // 3. Libera o QUARTO ORIGINAL no vetor 'quartos'
      quartos[indiceQuarto].disponivel <- verdadeiro
      
      escreva("\nCheck-out realizado com sucesso!\n")
      escreva("Cliente: ", reservas[indiceReserva].cliente.nome, "\n")
      escreva("Quarto ", quartos[indiceQuarto].numero, " agora está disponível.\n")
      escreva("Valor final pago: R$", reservas[indiceReserva].totalPagar:0:2, "\n")
   fimse
fimprocedimento

// --- Procedimento: Gerar Relatório de Ocupação ---
procedimento gerarRelatorioOcupacao()
var
   i, indiceQuarto: inteiro
   q: Quarto // Variável auxiliar
inicio
   limpatela
   escreva("==================================================================\n")
   escreva("=                  RELATÓRIO DE OCUPAÇÃO                     =\n")
   escreva("==================================================================\n")
   escreva("Status     | Quarto | Cliente                 | CPF           | Total\n")
   escreva("------------------------------------------------------------------\n")
   
   para i de 1 até totalReservas faca
      // Pega o índice do quarto salvo na reserva
      indiceQuarto <- reservas[i].indiceQuarto
      // Pega o quarto original para ter o NÚMERO
      q <- quartos[indiceQuarto]
      
      escreva(reservas[i].status:10, " | ")
      escreva(q.numero:6, " | ")
      escreva(reservas[i].cliente.nome:23, " | ")
      escreva(reservas[i].cliente.cpf:13, " | ")
      escreva("R$", reservas[i].totalPagar:7:2, "\n")
   fimpara
   escreva("==================================================================\n")
fimprocedimento

// --- Bloco Principal (Início da Execução) ---
inicio
   totalQuartos <- 0
   totalReservas <- 0
   opcao <- -1
   
   // Menu Principal
   repita
      limpatela
      escreva("=========================================\n")
      escreva("=      Sistema de Reservas de Hotel     =\n")
      escreva("=========================================\n")
      escreva(" Quartos: ", totalQuartos, "/", LIMITE_QUARTOS, " | Reservas: ", totalReservas, "/", LIMITE_RESERVAS, "\n")
      escreva("=========================================\n")
      escreva("1. Adicionar Quarto (Admin)\n")
      escreva("2. Verificar Disponibilidade\n")
      escreva("3. Fazer Reserva\n")
      escreva("4. Realizar Check-in\n")
      escreva("5. Realizar Check-out\n")
      escreva("6. Gerar Relatório de Ocupação\n")
      escreva("0. Sair\n")
      escreva("-----------------------------------------\n")
      escreva("Escolha uma opção: ")
      leia(opcao)

      escolha opcao
         caso 1
            adicionarQuarto()
            Pausar()
         caso 2
            verificarDisponibilidade()
            Pausar()
         caso 3
            fazerReserva()
            Pausar()
         caso 4
            realizarCheckIn()
            Pausar()
         caso 5
            realizarCheckOut()
            Pausar()
         caso 6
            gerarRelatorioOcupacao()
            Pausar()
         caso 0
            escreva("\nSaindo do sistema de reservas...\n")
         padrão
            escreva("\n[ERRO] Opção inválida.\n")
            Pausar()
      fimescolha
      
   até (opcao = 0)
fimalgoritmo
