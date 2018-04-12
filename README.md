# CLShell

## Cenários e Léxicos

### O que fazer
* São dois arquivos de entrada, um com todos os cenários e outro com todos os léxicos
* Primeira linha de cada arquivo deve ser o cabeçalho (ver exemplos)
* Os cabeçalhos são usados para criar as tabelas, então os campos são livres
* Veja modelo no [drive](https://docs.google.com/spreadsheets/d/1iN2dwby5QizNvTyToRokk6zpiTHsuqBnQFP9nqBGVTw/edit?usp=sharing)
* Fazer download como .tsv (Tab-separated values) para usar nesse script
* Quebras de linhas dentro das células devem ser indicadas com ;
* Primeiro campo (título/nome) de cada cenário/léxico é utilizado para o nome de cada arquivo.md gerado
* Último campo de cada léxico deve conter seus sinônimos (separados por ;)
* Sinônimos devem sempre terminat com ;
* Edite somente os arquivos de entrada, execute o script e substitua os arquivos gerados no git

### O que não fazer
* Utilizar ; no primeiro campo de cada cenário/léxico
* Repetir títulos/nomes
* Colocar plural ou singular dos nomes dos léxicos em seus sinônimos
* Repetir nomes dos léxicos em seus sinônimos
* Alterar na mão os arquivos gerados. Ao executar o script novamente todos os arquivos gerados anteriormente são apagados)

### Exemplos
Nome | Noção | Classificação | Impacto(s) | Sinônimo(s)
--- | --- | --- | --- | ---
Agenda de shows | Uma programação dos shows que o artista irá realizar | Objeto | O artista posta a agenda de shows para os usuários | Calendario de shows;
Artista | Usuário que deseja lançar álbum e agenda de shows | Sujeito | Spotify oferece mais funcionalidades | Músico;Cantor;
Internet | Rede mundial de computadores | Objeto | Informações; Acessar biblioteca | Rede mundial;
Usuário | pessoa que usa o aplicativo | Sujeito | Gera renda; Mantém músico | Cliente;

### Instruções de Uso
Após baixar do drive a planilha de cenários e a de léxicos separadamende como Tab-separated values (.tsv) executar o clshellmd.sh passando dois parâmetros. O primeiro parâmetro deve ser o arquivo.tsv com os cenários e o segundo deve ser o arquivo.tsv com os léxicos.

Um exemplo de uso:
```shell
bash clshellmd.sh Cenarios.tsv Lexicos.tsv
```

A saída estará no diretório CL criado um diretório acima de onde o script foi executado.
Os arquivos de entrada podem estar em qualquer lugar, é só passar o caminho no parâmetro.

Também é possível tornar o arquivo Shell Script em um executável. Exemplo:
```shell
chmod +x clshellmd.sh
```

Para executar:
```shell
./clshellmd.sh Cenarios.tsv Lexicos.tsv
```
