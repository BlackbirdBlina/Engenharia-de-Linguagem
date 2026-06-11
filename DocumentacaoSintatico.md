
<div align="center">    
    <p style="font-size: 12pt; line-height: 0.5; font-family: 'Times New Roman', serif;">Universidade Federal do Rio Grande do Norte</p>
    <p style="font-size: 12pt; line-height: 0.5; font-family: 'Times New Roman', serif;">Departamento de Informática e Matemática Aplicada</p>
    <p style="font-size: 12pt; line-height: 0.5; font-family: 'Times New Roman', serif;">DIM0548 – Engenharia de Linguagens</p>
</div>

<div style="margin-top: 25vh;"></div>

<div align="center">
    <h1 style="font-family: 'Times New Roman', serif;">DOCUMENTAÇÃO - ANALISADOR SINTÁTICO</h1>
    <h2 style="font-family: 'Times New Roman', serif;">KOJITO</h2>
</div>

<div style="margin-top: 15vh;"></div>

<div align="right">
    <p style="font-size: 12pt; line-height: 0.5; font-family: 'Times New Roman', serif;">EXPEDITO HEBERT FIRMINO DA ROCHA</p>
    <p style="font-size: 12pt; line-height: 0.5; font-family: 'Times New Roman', serif;">FRANCISCO GABRIEL COSTA BESSA</p>
    <p style="font-size: 12pt; line-height: 0.5; font-family: 'Times New Roman', serif;">JOSE CARLOS DA SILVA NASCIMENTO</p>
    <p style="font-size: 12pt; line-height: 0.5; font-family: 'Times New Roman', serif;">PEDRO VINÍCIUS BARBOSA PEREIRA</p>
    <p style="font-size: 12pt; line-height: 0.5; font-family: 'Times New Roman', serif;">SABRINA DA SILVA BARBOSA VENCESLAU</p>
</div>

<div style="margin-top: 25vh;"></div>

<div align="center" style="position: bottom;">
    <p style="font-size: 12pt; line-height: 0.5; font-family: 'Times New Roman', serif;">Natal - RN</p>
    <p style="font-size: 12pt; line-height: 0.5; font-family: 'Times New Roman', serif;">2026</p>
</div>


<div style="page-break-after: always;"></div>

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; padding: 20px;">
    <div align="center" style="margin-bottom: 40px;">
        <p style="font-size: 12pt; line-height: 0.5; font-family: 'Times New Roman', serif;">SUMÁRIO</p>
    </div>
    <div style="display: flex; flex-direction: column; gap: 10px;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end;">
            <span>
                <a href="#ESTRUTURA" style="text-decoration: none; color: black;">
                    <strong>1. ESTRUTURA DOS PROGRAMAS DA LINGUAGEM </strong>
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px "></span>
            <span><strong>3</strong></span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 20px;">
            <span>
                <a href="#Código-fonte" style="text-decoration: none; color: black;">
                    1.1 Código-fonte mínimo compilável
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>3</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 20px;">
            <span>
                <a href="#Exemplos" style="text-decoration: none; color: black;">
                    1.2 Exemplos gerais
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>4</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 40px;">
            <span>
                <a href="#Subprogramas" style="text-decoration: none; color: black;">
                    1.2.1 Subprogramas
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>4</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 60px;">
            <span>
                <a href="#Função" style="text-decoration: none; color: black;">
                    1.2.1.0 Função
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>4</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 60px;">
            <span>
                <a href="#PureFunção" style="text-decoration: none; color: black;">
                    1.2.1.1 Função Pura
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>4</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 60px;">
            <span>
                <a href="#Procedure" style="text-decoration: none; color: black;">
                    1.2.1.2 Procedimento
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>5</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 40px;">
            <span>
                <a href="#Atribuição" style="text-decoration: none; color: black;">
                    1.2.2 Atribuição
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>5</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 40px;">
            <span>
                <a href="#Repetição" style="text-decoration: none; color: black;">
                    1.2.3 Estruturas de Repetição
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>5</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 60px;">
            <span>
                <a href="#While" style="text-decoration: none; color: black;">
                    1.2.3.0 While
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>20</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 60px;">
            <span>
                <a href="#Loop" style="text-decoration: none; color: black;">
                    1.2.3.1 Loop
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>20</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 60px;">
            <span>
                <a href="#For" style="text-decoration: none; color: black;">
                    1.2.3.2 For
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>20</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 40px;">
            <span>
                <a href="#Decisão" style="text-decoration: none; color: black;">
                    1.2.4 Estruturas de Decisão
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>20</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 60px;">
            <span>
                <a href="#If" style="text-decoration: none; color: black;">
                    1.2.4.0 If-Else
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>20</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 60px;">
            <span>
                <a href="#match" style="text-decoration: none; color: black;">
                    1.2.4.1 Match
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>20</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end;">
            <span>
                <a href="#EstruturaAnalisadores" style="text-decoration: none; color: black;">
                    <strong>2. ESTRUTURA DOS ANALISADORES</strong>
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span><strong>15</strong></span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 20px;">
            <span>
                <a href="#AnalisadorLexico" style="text-decoration: none; color: black;">
                    2.1 Analisador Léxico: principais tarefas, decisões e dificuldades
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>18</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 20px;">
            <span>
                <a href="#AnalisadorSintatico" style="text-decoration: none; color: black;">
                    2.2 Analisador Sintático: principais tarefas, decisões e dificuldades
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>18</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 20px;">
            <span>
                <a href="#Limitacoes" style="text-decoration: none; color: black;">
                    2.3 Limitações da implementação atual
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>18</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end;">
            <span>
                <a href="#Uso" style="text-decoration: none; color: black;">
                    <strong>3. USO DO ANALISADOR SINTÁTICO</strong>
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span><strong>25</strong></span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 20px;">
            <span>
                <a href="#ComoGerar" style="text-decoration: none; color: black;">
                    3.1 Como gerar o analisador sintático
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>18</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding-left: 20px;">
            <span>
                <a href="#Testes" style="text-decoration: none; color: black;">
                    3.2 Programas de Teste e resultados esperados
                </a>
            </span>
            <span style="flex-grow: 1; border-bottom: 1px dotted #000000; margin: 0 10px; position: relative; top: -4px;"></span>
            <span>18</span>
        </div>
    </div>
</div>

<div style="page-break-after: always;"></div>

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="ESTRUTURA" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 1. ESTRUTURA DOS PROGRAMAS DA LINGUAGEM </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        A estrutura de um programa em uma linguagem de programação imperativa e compilada se dá a partir de como as coisas são postas em código, ou seja, como os comandos são feitos para que se possa gerar um executável. Dessa forma, tratando-se de Kojito, mostraremos como um programa será estruturado em nossa linguagem nas próximas seções.
    </p>
</div>

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="Código-fonte" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 1.1 Código-fonte mínimo compilável </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        Utilizamos o algoritmo do Merge Sort estruturado em nossa linguagem, como exemplo de um código-fonte compilável: 
    </p>
</div>

```rust
func merge(left : &[u_int32], right : &[u_int32]) -> Vec<u_int32> {
   let result: Vec<u_int32> = Vec::with_capacity(left.len() + right.len());


   let r : [u_int32; 5] = left;
   let i : u_int32 = 0;
   let j : u_int32 = 0;
   while (i < left.len() && j < right.len()) { 
       if (left[i] <= right[j]) {
           result.push(left[i]);
           i++;
       } else {
           result.push(right[j]);
           j++;
       }
   }
   while (i < left.len()) {
       result.push(left[i]);
       i++;
   }
   while (j < right.len()) {
       result.push(right[j]);
       j++;
   }


   return result;
}


func merge_sort(arr: &[u_int32]) -> Vec<u_int32> {
   if (arr.len() <= 1) {
       return arr.to_vec();
   }
   let mid : u_size = arr.len() / 2;
   let left : u_int32 = merge_sort(&arr[..mid]); 
   let right : u_int32 = merge_sort(&arr[mid..]);


   return merge(&left, &right);
}

func foo() -> s_int32 {
    return s;
}

func main(i:u_int8) -> Result<(), String> {
   let array : [s_int32; 5] = [5, 4, 3, 2, 1];
   let result : Vec<u_int32> = merge_sort(&array);
   for (i in result) {
       print("{}", i);
   }
   print("\n");
   return Ok(());
}
```
<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="Exemplos" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 1.2 Exemplos gerais </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        Para entender melhor como nossa linguagem é estruturada, abaixo seguem os exemplos gerais de como escrever funções, declarações, estruturas de decisão, de repetição, structs e qualquer outro componente posível de ser escrito em nossa linguagem:
    </p>
</div>

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="Subprogramas" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 1.2.1 Subprogramas </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        Nossa linguagem terá três categorias de subprogramas: função, função pura e procedimento.
    </p>
</div>

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="Funçoes" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 1.2.1.0 Função </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        As funções em nossa linguagem terão um tipo de entrada e, obrigatoriamente, um tipo de retorno, elas podem causar efeitos colaterais, portanto podem alterar variáveis recebidas por referência e variáveis globais. Uma função terá a seguinte sintaxe:
    </p>
</div>

```rust
func noFunc(u8 : u_int8, u16 : u_int16) -> char {
    u8 = 3;
    return 'c';
}
```
<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="PureFunção" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 1.2.1.1 Função Pura </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        As funções puras terão um tipo de entrada e, obrigatoriamente, um tipo de retorno, elas não podem causar efeitos colaterais, portanto o programador terá que seguir um série de regras ao escrever dentro delas, como:
    </p>
</div>

```rust
pure func pureNoFunc(u8 : u_int8, u16 : u_int16) -> char {
    return 'f';
}
```

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="Procedure" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 1.2.1.2 Procedimento </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        Os procedimentos terão apenas tipos de entrada, também podem não possuir nenhum, eles podem causar efeitos colaterais, portanto podem alterar variáveis recebidas por referência e variáveis globais. Os procedimentos terão a seguinte sintaxe:
    </p>
</div>

```rust
proced procedures(u8 : u_int8) {
    u8 = 3;
}
```

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="Atribuição" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 1.2.2 Atribuição </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        Considerando que temos como um de nossos objetivos a segurança de memória, previsibilidade e tipagem forte — Kojito adotará um conjunto restrito e controlado de formas de atribuição.
    </p>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        Dito isto, será suportada a atribuição simples, sendo esta a forma principal de modificação de estado, seguindo uma sintaxe clara e obrigatoriamente tipada,
    </p>
</div>

```rust
let s8  : s_int8 = 8;
```
<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="Repetição" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 1.2.3 Estruturas de repetição </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        Nossa linguagem terá apenas as estruturas while, loop e for. Optamos por não incluir o do-while, em alternativa temos o loop que é mais simples, tornando a linguagem mais fácil de aprender e mais segura (evitando execuções acidentais de blocos de código), além de que o loop tem mais possibilidade de uso do que o do-while, que é geralmente pouco utilizado.
    </p>
    
</div>

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="While" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 1.2.3.0 While </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        A estrutura do while é feita da seguinte forma:
    </p>
    
</div>

```rust
while (true) {}
```
<div style="page-break-after: always;"></div>

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="Loop" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 1.2.3.1 Loop </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        A estrutura do Loop é feita da seguinte forma:
    </p>
    
</div>

```rust
loop {
        break;
    }
```

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="For" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 1.2.3.2 For </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        A estrutura do For é feita da seguinte forma:
    </p>
    
</div>

```rust
for (i in 0..9) {
        continue;
    }
```

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="Decisão" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 1.2.4 Estruturas de decisão </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        Nossa linguagem terá apenas as estruturas if-else e match:
    </p>
    
</div>

```rust
for (i in 0..9) {
        continue;
    }
```

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="If" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 1.2.4.0 If-else </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        A estrutura do if-else é feita da seguinte forma:
    </p>
    
</div>

```rust
if (true) {}
```
<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="match" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 1.2.4.1 Match </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        A estrutura do match é feita da seguinte forma:
    </p>
    
</div>

```rust
match (res) {
        Ok(u) = {};
        Erro(s) = {};
    }
```
<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <p style="text-indent: 50px; margin-bottom: 12px;">
        Os demais exemplos podem ser consultados no arquivo examples/all_tests.kjt.
    </p>
    
</div>

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="EstruturaAnalisadores" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 2. ESTRUTURA DOS ANALISADORES </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        O compilador da linguagem Kojito foi desenvolvido utilizando duas ferramentas amplamente empregadas na construção de compiladores: o Flex, responsável pela análise léxica, e o Bison, responsável pela análise sintática. Essa divisão permite separar o reconhecimento dos elementos básicos da linguagem da validação de sua estrutura gramatical, tornando o projeto mais organizado e modular.
    </p>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        Durante a compilação, o código-fonte é inicialmente processado pelo analisador léxico, que identifica palavras reservadas, operadores, identificadores, literais e demais símbolos definidos pela linguagem. Cada elemento reconhecido é convertido em um token, que posteriormente é encaminhado ao analisador sintático.
    </p>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        O analisador sintático recebe a sequência de tokens produzida pelo analisador léxico e verifica se ela está de acordo com as regras gramaticais da linguagem Kojito. Para isso, foi definida uma gramática livre de contexto capaz de reconhecer construções como declarações de variáveis, funções, procedimentos, estruturas de decisão, estruturas de repetição, expressões, tipos compostos e demais componentes da linguagem.
    </p>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        A comunicação entre os dois analisadores ocorre de forma transparente: o Flex identifica os tokens e o Bison os consome para validar a estrutura do programa. Caso seja encontrada alguma inconsistência sintática, o analisador informa a linha e o trecho do código onde o erro ocorreu, facilitando sua correção.
    </p>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        A arquitetura adotada segue o fluxo tradicional de compilação, representado da seguinte forma:
    </p>
    <div align="center" style="margin: 20px 0;">
        <strong>Código-fonte → Analisador Léxico (Flex) → Tokens → Analisador Sintático (Bison) → Programa Validado</strong>
    </div>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        Essa abordagem simplifica a manutenção do compilador, facilita a evolução da linguagem e permite que novas funcionalidades sejam adicionadas futuramente sem a necessidade de reestruturar completamente o processo de análise.
    </p>
</div>

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="AnalisadorLexico" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 2.1 Analisador Léxico: principais tarefas, decisões e dificuldades </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        O analisador léxico da linguagem Kojito foi implementado utilizando o Flex e tem como principal objetivo transformar o código-fonte em uma sequência de tokens compreensíveis pelo analisador sintático. Para isso, foram definidas expressões regulares capazes de reconhecer palavras reservadas, identificadores, operadores, delimitadores, tipos primitivos e literais da linguagem.
    </p>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        Entre os elementos reconhecidos encontram-se palavras-chave como <code>func</code>, <code>let</code>, <code>if</code>, <code>while</code>, <code>struct</code> e <code>enum</code>, além de tipos como <code>u_int32</code>, <code>float64</code>, <code>bool</code> e estruturas genéricas como <code>Vec</code>, <code>Result</code> e <code>Option</code>.
    </p>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        Também foram implementadas regras para ignorar comentários de linha e comentários de bloco, evitando que esses elementos interfiram na análise sintática. Espaços em branco e quebras de linha são tratados adequadamente, sendo utilizadas apenas para controle de posição e geração de mensagens de erro.
    </p>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        Uma das principais dificuldades encontradas durante o desenvolvimento foi garantir que operadores compostos fossem reconhecidos corretamente sem conflito com operadores simples. Exemplos incluem os pares <code>>=</code> e <code>></code>, <code>==</code> e <code>=</code>, além dos operadores de atribuição composta, como <code>+=</code> e <code>*=</code>.
    </p>
</div>

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="AnalisadorSintatico" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 2.2 Analisador Sintático: principais tarefas, decisões e dificuldades </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        O analisador sintático foi desenvolvido utilizando o Bison e é responsável por validar a estrutura dos programas escritos em Kojito. Sua implementação baseia-se em uma gramática livre de contexto capaz de reconhecer os diferentes elementos da linguagem e verificar se eles foram utilizados de forma correta.
    </p>
</div>

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="Limitacoes" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 2.3 Limitações da implementação atual </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        TEXTO
    </p>
</div>

<div style="page-break-after: always;"></div>

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="Uso" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 3. Uso do analisador sintático </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        TEXTO
    </p>
</div>

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="ComoGerar" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 3.1 Como gerar o analisador sintático. </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        TEXTO
    </p>
</div>

<div style="font-size: 12pt; line-height: 1.5; font-family: 'Times New Roman', serif; text-align: justify;">
    <h1 id="Testes" style="font-size: 12pt; font-family: 'Times New Roman', serif; margin-bottom: 24px; text-transform: uppercase;"> 3.2 Programas de Teste e resultados esperados </h1>
    <p style="text-indent: 50px; margin-bottom: 12px;">
        TEXTO
    </p>
</div>