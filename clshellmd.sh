#/bin/bash

mkdir -p ../CL;
pasta1="Cenários";
pasta2="Léxicos";

OIFS=$IFS;
IFS='
';

geraCL()
{
	mkdir -p ../CL/$2;
	for linha in `sed '1d' $1`; do
		# primeiro campo é o nome de cada C e L. Arquivos md trocam espaços por hifens
		titulo=`echo $linha | cut -f1 | sed 's/ /-/g'`;
		# nome e caminho de cada arquivo
		arquivo=../CL/$2/$titulo.md;
		# cabeçalho do arquivo
		echo "#$3" > $arquivo;
		OIFS2=$IFS;
		# para o sed usar tab como separador de campo no for
		IFS=$'\t';
		# count para iterar em cada valor de cada campo
		count=1;
		# itera em cada campo da primeira linha do arquivo csv (cabeçalho, igual para cada C e L)
		for campo in `sed '1!d' $1`; do
			IFS=$OIFS2;
			# ; siginifica quebra de linh (para separar/listar itens), como é tabela em md, <br> é mais prático
			valor=$(echo $linha | cut -f$count | sed 's/;/<br>/g');
			echo "$campo | $valor " >> $arquivo;
			count=$((count+1));
		done
	done
}

geraLinks()
{
	for linha in `sed '1d' $1`; do
		# link é o texto que será buscado em cada arquivo
		link=`echo $linha | cut -f1`;
		# nome do arquivo para ser usado para gera o link e para não criar links redundantes(em seu próprío arquivo)
		arquivo=`echo $link | sed 's/ /-/g'`;
		buscaEtroca $arquivo $link $2;
	done
}

geraPaginaPrincipal()
{
	echo "#$pasta1 e $pasta2" > ../CL/cl.md;
	echo "-----" >> ../CL/cl.md;
	echo "##$pasta1" >> ../CL/cl.md;
	geraLista $1 $pasta1 ../CL/cl.md;
	echo "-----" >> ../CL/cl.md;
	echo "##$pasta2" >> ../CL/cl.md;
	geraLista $2 $pasta2 ../CL/cl.md;
}

geraLista()
{
	for linha in `sed '1d' $1`; do
		link=`echo $linha | cut -f1`;
		arquivo=`echo $link | sed 's/ /-/g'`;
		# escreve no arquivo passado no campo 3
		echo "[$link]($2/$arquivo.md)" >> $3;
	done
}

geraSinonimos()
{
	for linha in `sed '1d' $1`; do
		arquivo=`echo $linha | cut -f1 | sed 's/ /-/g'`;
		for sinonimos in `echo $linha | rev | cut -f1 | rev`; do
			OIFS3=$IFS
			IFS=';';
			for sinonimo in $sinonimos; do
				IFS=$OIFS3;
				buscaEtroca $arquivo $sinonimo $2;
			done
		done
	done
}

buscaEtroca()
{
	# busca em todos os arqs da pasta(-R) CL, de forma case INsensitive(-i) e retornando somente o nome e caminho(-l) do arquivo encontrado
	# $1 é o nome e caminho do arquivo, $2 é a string a ser buscada e $3 é o nome da pasta para se rusada no caminho do link em md
	grep -ilR --exclude="$1.md" $2 ../CL/ > temp;
	for arq in `cat temp`; do
		# substitui(s) de forma case Insensitive(I) a string buscada em todos as linhas(g) do arquivo
		sed -i "s@$2@\[&\]\($3/$1.md\)@Ig" $arq;
	done
	rm temp;
}

geraListaCL()
{
	for linha in `sed '1d' $1`; do
		# primeiro campo é o nome de cada C e L. Arquivos md trocam espaços por hifens
		titulo=`echo $linha | cut -f1 | sed 's/ /-/g'`;
		# próximas linhas geram listas com links de todos os C e L para cada um dos C e L
		echo "-----" >> ../CL/$2/$titulo.md;
		echo "##$2" >> ../CL/$2/$titulo.md;
		geraLista $1 $2 ../CL/$2/$titulo.md;
		echo "-----" >> ../CL/$2/$titulo.md;
		echo "##$4" >> ../CL/$2/$titulo.md;
		geraLista $3 $4 ../CL/$2/$titulo.md;
	done
}

sed '$d' $1 > cenario;
sed '$d' $2 > lexico;

geraCL cenario $pasta1 "Cenário";
geraCL lexico $pasta2 "Léxico";
geraLinks cenario $pasta1;
geraLinks lexico $pasta2;
geraPaginaPrincipal cenario lexico;
geraSinonimos lexico $pasta2;
#deve ser chamado depois do geraLinks e geraSinonimos para não gerar link dentro de link
geraListaCL cenario $pasta1 lexico $pasta2;
geraListaCL lexico $pasta2 cenario $pasta1;

rm cenario;
rm lexico;

IFS=$OIFS;
