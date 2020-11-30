function New-CsvSplitter {

<#
.SYNOPSIS
    Split a large CSV files in multiple CSV files.

.DESCRIPTION
    New-CsvSplliter is a function that receive a input path of CSV file and split this file in multiples smaller files. This function start in the second line of file understanding the first line like headers of data.

.PARAMETER SourceFilePath
    This parameter indicate the full path of input CSV file.

.PARAMETER DestinationPath
    This parameter indicate the output folder for the new CSV files. By default the atual path is used for output.

.PARAMETER NumberOfOutFiles
    This parameter indicate the number of CSV files to be created in the output. This function automatically calculate the number of lines will be created in each CSV output file, by default two files will be generated.

.PARAMETER InitialLine
    This parameter indicate ther first line to be used in the processing. The default value is 1, this will ignore the first line considering this line like a header.

.PARAMETER Delimiter
    This parameter indicate the delimiter used to recognize the data of source CSV. This delimiter will be used in generation of output files.

.PARAMETER Preffix
    This parameter indicate which will be the preffix to create the name of output files. By default the preffix will not be used.

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
    
.LINK
    https://github.com/hmizael/generic/tree/main/New-CsvSplitter

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
    Write-Verbose "Read source file $SourceFilePath from the line $InitialLine."
    $EndLine = 0
    $Records = [int][Math]::Ceiling($Content.Count / $NumberOfOutFiles)
    Write-Verbose "Will be about $Records records in each of the $NumberOfOutFiles output files."
    for ($i = 1; $i -le $NumberOfOutFiles; $i++) { 
        $Path = Join-Path -Path $DestinationPath -ChildPath "$Preffix$i.csv"

        $Endline += $Records
        $Content[$StartLine..$EndLine] | Export-Csv -Path $Path -NoTypeInformation -Delimiter $Delimiter
        Write-Verbose "`tFile $Path created."
        $StartLine = $EndLine + 1
    }
}
