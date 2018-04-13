#/bin/bash

mkdir -p ../CL;
cenario="Cenários";
lexico="Léxicos";

# guarda o Inter Field Separator atual
OIFS=$IFS;
# muda o IFS para quebra de linha
IFS='
';

geraCL()
{
	for linha in `sed '1d' $1`; do
		# primeiro campo é o nome de cada C e L. Arquivos md trocam espaços por hifens
		titulo=`echo $linha | cut -f1 | sed 's/ /-/g'`;
		# nome e caminho de cada arquivo
		arquivo=../CL/$titulo.md;
		# cabeçalho do arquivo
		echo "# $2" > $arquivo;
		echo >> $arquivo;
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
			echo "**$campo** | $valor " >> $arquivo;
			count=$((count+1));
		done
		echo >> $arquivo;
		# cria md table
		sed -i '4i --- | --- ' $arquivo;
		# remove ^M (carriage Return)
		sed -i 's/\r//g' $arquivo;
	done
}

geraLinks()
{
	for linha in `sed '1d' $1`; do
		# link é o texto que será buscado em cada arquivo
		link=`echo $linha | cut -f1`;
		# nome do arquivo para ser usado para gera o link e para não criar links redundantes(em seu próprío arquivo)
		arquivo=`echo $link | sed 's/ /-/g'`;
		buscaEtroca $arquivo $link;
	done
}

geraPaginaPrincipal()
{
	echo "## $cenario" > ../CL/$cenario-e-$lexico.md;
	geraLista $1 ../CL/$cenario-e-$lexico.md;
	echo "-----" >> ../CL/$cenario-e-$lexico.md;
	echo "## $lexico" >> ../CL/$cenario-e-$lexico.md;
	geraLista $2 ../CL/$cenario-e-$lexico.md;
	geraSidebar $1 $2;
}

geraLista()
{
	for linha in `sed '1d' $1`; do
		link=`echo $linha | cut -f1`;
		arquivo=`echo $link | sed 's/ /-/g'`;
		# escreve no arquivo passado no parametro 2
		echo "* [$link]($arquivo)" >> $2;
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
				buscaEtroca $arquivo $sinonimo;
			done
		done
	done
}

buscaEtroca()
{
	numHash=`cksum <<< $2`;
	echo -e "$numHash\t[$2]($1)" >> links;
	# busca em todos os arqs da pasta(-R) CL (menos no arquivo do próprio termo buscado) e retornando somente o nome e caminho(-l) do arquivo encontrado
	# $1 é o nome e caminho do arquivo e $2 é a string a ser buscada
	grep -lR --exclude="$1.md" $2 ../CL/ > temp;
	for arq in `cat temp`; do
		# substitui(s) a string buscada em todos as ocorrências(g) no arquivo, exceto na linha 3 (título/nome)
		sed -i "3!s/$2/$numHash/g" $arq;
	done
	rm temp;
}

trocaNumHash()
{
	sed 's/\r//g' links | grep -v '\[]' > lista;
	rm links;
	for linha in `cat lista`; do
		numH=`echo $linha | cut -f1`;
		valor=`echo $linha | cut -f2`;
		# busca em todos os arqs da pasta(-R) CL e retornando somente o nome e caminho(-l) do arquivo encontrado
		grep -lR $numH ../CL/ > temp;
		for arq in `cat temp`; do
			# substitui(s) a string buscada em todos as ocorrências(g) do arquivo
			sed -i "3!s/$numH/$valor/g" $arq;
		done
		rm temp;
	done
	rm lista;
}

geraListaCL()
{
	for linha in `sed '1d' $1`; do
		# primeiro campo é o nome de cada C e L. Arquivos md trocam espaços por hifens
		titulo=`echo $linha | cut -f1 | sed 's/ /-/g'`;
		# próximas linhas geram listas com links de todos os C e L para cada um dos C e L
		echo "-----" >> ../CL/$titulo.md;
		echo "## $2" >> ../CL/$titulo.md;
		geraLista $1 ../CL/$titulo.md;
		echo "-----" >> ../CL/$titulo.md;
		echo "## $4" >> ../CL/$titulo.md;
		geraLista $3 ../CL/$titulo.md;
	done
}

geraSidebar()
{
	echo "* [$cenario e $lexico]($cenario-e-$lexico)" > ../CL/_Sidebar.md;
	echo "## $cenario" >> ../CL/_Sidebar.md;
	geraLista $1 ../CL/_Sidebar.md;
	echo "## $lexico" >> ../CL/_Sidebar.md;
	geraLista $2 ../CL/_Sidebar.md;
}

cat $1 > cenario;
cat $2 > lexico;

#chamada das funcoes
geraCL cenario "Cenário";
geraCL lexico "Léxico";
geraLinks cenario;
geraLinks lexico;
geraPaginaPrincipal cenario lexico;
geraSinonimos lexico;
trocaNumHash;
#deve ser chamado depois do geraLinks e geraSinonimos para não gerar link dentro de link
geraListaCL cenario $cenario lexico $lexico;
geraListaCL lexico $lexico cenario $cenario;
###

rm cenario;
rm lexico;

#devolve o IFS original
IFS=$OIFS;
