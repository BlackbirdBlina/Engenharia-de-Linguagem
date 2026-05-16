# Documentação Linguagem de Programação - Kojito

## Pré-requisitos

- Flex e GCC

## Como executar

```bash
# 1. Clone o repositório
git clone https://github.com/BlackbirdBlina/Engenharia-de-Linguagem.git
cd EngenhariaLinguagem
cd src

# 2. Instale o Fast Lexical Analyzer Generator (Flex)
sudo apt-get install flex

# 3. Gere o código C
flex arquivo.l

# 4. Compile o arquivo lex.yy.c
gcc lex.yy.c -ll

# 5. Execute o ./a.out gerado passando o fluxo de entrada para ele
./a.out < nomePrograma.kjt
```

- Nome da linguagem: Kojito

![Kojito](LogoKojito.png)

- Proposta:

    - Linguagem imperativa com foco educacional relacionado especialmente à segurança de memória.

    - Utiliza majoritariamente critérios de legibilidade e confiabilidade.

- Exemplo básico:

```bash
func main() -> Result<(), String> {
   println("Hello World");
   return Ok(());
}
```

## Especificação da sintaxe

### Variáveis e tipos

- Na linguagem Kojito, usamos tipagem estática.

    ```bash
    // Declaração de variável
    let a : u_int32 = 0;
    let b : String = “Hello!”;
    ```
### Estruturas de decisão e repetição

- Na linguagem Kojito, usamos if e else, bem como while, for e loop

    ```bash
    // Estrutura if
    if (idade <= 18) {
           println("Maior de idade");
    } else {
           println("Menor de idade");
    }

    // Estrutura while
    while (n < 10) {
        println("{n}\n");
    }
    n += 1;
    ```