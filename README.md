# 🏨 Sistema de Reservas de Hotel (Portugol)

Este é um algoritmo de console robusto que simula o fluxo completo de gerenciamento de um hotel, desde o cadastro de quartos até o check-out dos hóspedes. O projeto demonstra o uso de Registros (`tipo`), vetores, modularização com funções de busca e a correção de um bug crítico de lógica de negócios.



## ✨ Funcionalidades Principais

* **1. Adicionar Quarto (Admin):**
    * Permite cadastrar novos quartos no sistema (ex: Nº 101, 202).
    * **Validação:** Impede o cadastro de quartos com **números duplicados**.
    * **Validação:** Utiliza um menu numérico para definir o tipo (Simples, Luxo, Executivo), evitando erros de digitação e definindo o preço automaticamente.

* **2. Verificar Disponibilidade:**
    * Exibe uma lista formatada de todos os quartos que estão com o status `disponivel = verdadeiro`.

* **3. Fazer Reserva:**
    * O fluxo principal de negócios. O sistema pede o número do quarto, os dados do cliente e os dias de estadia.
    * **Validação:** A reserva só é permitida se o quarto **existir** E estiver **disponível**.
    * **Cálculo de Tarifa:** Utiliza uma `funcao` para calcular o valor total, aplicando um desconto automático de 10% para estadias de 7 dias ou mais.
    * **Ação:** Marca o quarto original como `disponivel = falso`.

* **4. Realizar Check-in:**
    * Altera o status de uma reserva de "Reservado" para "Check-in", simulando a chegada do hóspede.
    * **Validação:** Só funciona se houver uma reserva "Reservada" para o CPF informado.

* **5. Realizar Check-out:**
    * Altera o status de uma reserva de "Check-in" para "Check-out".
    * **Lógica Corrigida:** Libera o quarto original no sistema, marcando `quartos[indice].disponivel = verdadeiro`.

* **6. Gerar Relatório de Ocupação:**
    * Exibe uma lista de todas as reservas feitas, mostrando o status ("Reservado", "Check-in", "Check-out"), os dados do cliente e o valor total.

## 🏛️ Estrutura e Lógica Aprimorada

Este algoritmo foi refatorado para corrigir uma falha lógica crítica e otimizar a estrutura de dados.

### 1. Correção do "Bug do Check-out" (A Melhoria Crítica)

* **Problema Original:** O `tipo Reserva` armazenava uma **cópia** inteira do `tipo Quarto`. No check-out, o código tentava `reservas[i].quarto.disponivel ← verdadeiro`. Isso alterava apenas a *cópia* dentro da reserva, mas o *quarto original* no vetor `quartos` permanecia `disponivel = falso` para sempre.
* **Solução Aprimorada:** O `tipo Reserva` foi modificado para armazenar apenas o `indiceQuarto` (um inteiro). Agora, o procedimento `realizarCheckOut` usa esse índice para encontrar o quarto exato no vetor `quartos` (o original) e alterar sua disponibilidade para `verdadeiro`, liberando-o corretamente para a próxima reserva.

### 2. Funções de Busca (Integridade do Sistema)
Em vez de usar loops `para` dentro de cada procedimento, o sistema agora é centralizado em funções de busca que garantem a integridade dos dados:

* `funcao buscarQuartoPorNumero(numero)`: Retorna o **índice** (posição) do quarto no vetor. É usado para validar se um quarto existe, se está duplicado ou para fazer a reserva.
* `funcao buscarReservaAtivaPorCPF(cpf, status)`: Encontra uma reserva ativa para um cliente, essencial para os fluxos de Check-in e Check-out.

## 🚀 Como Executar

Para executar este algoritmo, você precisará de um interpretador de Portugol.

1.  **VisualG (Recomendado):**
    * Baixe e instale o [VisualG](http://visualg.com.br/cli/).
    * Copie o código-fonte (`.alg`) do arquivo.
    * Abra o VisualG e cole o código.
    * Pressione **F9** (ou clique em "Rodar") para executar o programa.
