function New-CsvSplitter {
    
    <#
    .SYNOPSIS
        Quebra um arquivo Csv em varios arquivos menores.
    
    .DESCRIPTION
        New-CsvSplliter é uma função que recebe como entrada o caminho de um arquivo Csv para que este seja dividido em vários arquivos menores. Esta função inicia na segunda linha do arquivo entendendo que a primeira linha é composta de cabeçalhos.
    
    .PARAMETER SourceFilePath
        Indica o caminho completo do arquivo de origem.
    
    .PARAMETER DestinationPath
        Indica a pasta de saída para os novos arquivos. A localização atual é usada por padrão.
    
    .PARAMETER NumberOfOutFiles
        Indica a quantidade de arquivos a serem gerados na saída. A função calcula a quantidade de linhas do Csv que deverão conter em cada arquivo de saída. Por padrão 2 arquivos serão gerados.
    
    .PARAMETER InitialLine
        Indica a primeira linha a ser usada no processamento. O valor padrão é 1, para assim ignorar a linha de cabeçalho.
    
    .PARAMETER Delimiter
        Indica qual será o delimitador usado para reconhecer o conteudo do Csv de origem. O mesmo delimitador será utilizado para a geração dos arquivos de saída.
    
    .PARAMETER Preffix
        Indica qual será o prefixo para a criação do nome dos arquivos de saída. Por padrão não se usa um prefixo.
    
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
        Write-Verbose "Serão cerca de $Records registros em cada um dos $NumberOfOutFiles arquivos de saída."
        for ($i = 1; $i -le $NumberOfOutFiles; $i++) { 
            $Path = Join-Path -Path $DestinationPath -ChildPath "$Preffix$i.csv"
    
            $Endline += $Records
            $Content[$StartLine..$EndLine] | Export-Csv -Path $Path -NoTypeInformation -Delimiter $Delimiter
            Write-Verbose "`tArquivo $Path gerado."
            $StartLine = $EndLine + 1
        }
    }
    
