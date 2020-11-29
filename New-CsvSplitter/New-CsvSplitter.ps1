function New-CsvSplitter {
    
<#
.SYNOPSIS
    Quebra um arquivo Csv em varios arquivos menores.

.DESCRIPTION
    New-CsvSplliter e uma função que recebe como entrada o caminho de um arquivo Csv para que este seja dividido em varios arquivos menores. Esta funcao iniciara na seguda linha do arquivo entendendo que a primeira linha e composta de cabecalhos.

.PARAMETER SourceFilePath
    Indica o caminho completo do arquivo de origem.

.PARAMETER DestinationPath
    Indica a pasta de saida para os novos arquivos. A localizacao atual e usada por padrao.

.PARAMETER NumberOfOutFiles
    Indica a quantidade de arquivos a serem gerados na saida. A funcao calculara quantas linhas do Csv deverao conter em cada arquivo de saida. Por padrao 2 arquivos serao gerados.

.PARAMETER InitialLine
    Indica a primeira linha a ser usada no processamento. O valor padrao e 1, para assim ignorar a linha de cabecalho.

.PARAMETER Delimiter
    Indica qual sera o delimitador usado para reconhecer o conteudo do Csv de origem. O mesmo delimitador sera utilizado para a geracao dos arquivos de saida.

.PARAMETER Preffix
    Indica qual sera o prefixo para a criacao do nome dos arquivos de saida. Por padrao nao se usa um prefixo.

.EXAMPLE
    New-CsvSplitter -SourceFilePath "C:\CsvSplit\SourceCsv.csv"

.EXAMPLE
    New-CsvSplitter -SourceFilePath "C:\CsvSplit\SourceCsv.csv" -DestinationPath "C:\CsvSplitted"

.EXAMPLE
    New-CsvSplitter -SourceFilePath "C:\CsvSplit\SourceCsv.csv" -DestinationPath "C:\CsvSplitted" -NumberOfOutFiles 8 -Delimiter "," -Preffix "CsvSplitted-"

.INPUTS
    String, Char, Int

.OUTPUTS
    Files

.NOTES
    Author: Henrique Mizael
    GitHub: https://github.com/hmizael
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$SourceFilePath,

        [Parameter()]
        [string]$DestinationPath = (Get-Location),

        [Parameter()]
        [int]$NumberOfOutFiles = 2,

        [Parameter()]
        [int]$InitialLine = 1,

        [Parameter()]
        [char]$Delimiter = ';',

        [Parameter()]
        [string]$Preffix = ''
    )

    $Content = Import-Csv $SourceFilePath -Delimiter $Delimiter
    $StartLine = $InitialLine
    Write-Verbose "Lido arquivo de origem $SourceFilePath a partir da linha $InitialLine."
    $EndLine = 0
    $Records = [int][Math]::Ceiling($Content.Count / $NumberOfOutFiles)
    Write-Verbose "Serao cerca de $Records registros em cada um dos $NumberOfOutFiles arquivos de saida."
    for ($i = 1; $i -le $NumberOfOutFiles; $i++) { 
        $Path = Join-Path -Path $DestinationPath -ChildPath "$Preffix$i.csv"

        $Endline += $Records
        $Content[$StartLine..$EndLine] | Export-Csv -Path $Path -NoTypeInformation -Delimiter $Delimiter
        Write-Verbose "`tArquivo $Path gerado."
        $StartLine = $EndLine + 1
    }
}
