# Documentação Linguagem de Programação - Kojito

## Pré-requisitos

- Flex e GCC

## Como executar

```bash
# 1. Clone o repositório
git clone https://github.com/BlackbirdBlina/Engenharia-de-Linguagem.git
cd EngenhariaLinguagem

# 2. Instale o Fast Lexical Analyzer Generator (Flex)
sudo apt-get install flex

# 3. Use o makefile para gerar os binários
make

# 4. Execute os binários gerados
make run
```

- Nome da linguagem: Kojito

![Kojito](documentations/LogoKojito.png)

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

    ```c
    // Declaração de variável
    let a : u_int32 = 0;
    let b : String = “Hello!”;
    ```

### Estruturas de decisão e repetição

- Além disso, usamos if e else, bem como while, for e loop.

    ```c
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

    // Estrutura loop
    let i : u_int8 = 0; 
    loop {
        println("{n}\n");

        if (i == 20) {
            break;
        }

        i++;
    }
    ```

### Referências

- Quando uma variável é definida, ela terá apenas um dono,
que será a função que a declarou. Se for preciso outra função
olhar e modificar o valor dela, precisará ser passado uma referência,
da seguinte maneira:

    ```c
    func transform_to_zero(i: &mut u8) {
        *i = 0
    }

    func main() {
        let t : u_int16 = 10;
        transform_to_zero(&mut t);
    }
    ```

### Funções

- Além do modo tradicional de declarar uma função, onde é colocado
os inputs e o retorno, temos também a opção de anteceder a palavra
chave com um "pure", garantindo que a função não 

    ```c
    pure func return_zero() -> u8 {
        return 0;
    }

    func main() {
        let t : u_int32 = 10;
        println( "{}", return_zero() );
    }
    ```

### Procedures

- Também é possível definir um subprograma que garante que não é
retornado variáveis, usando a palavra chave procedure.

    ```c
    procedure print() {
        println("Oi!");
    }
    ```

### Struct, Enum e Union

```c
    enum Directions {
        North,
        West,
        South,
        East
    }

    struct Aluno {
        String name;
        u_int16 age = 0;
    }

    func main() {
        let aluno = Aluno {
            name: "Pedro",
            age: 20,
        }

        let dir = Direction.North;
    }


```


