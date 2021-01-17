function Export-RegexExpression {
    param (
        [string[]]$Word,
        [bool]$Or = $false
    )

    $WordinRegex = @()

    foreach ($item in $Word) {
        $characters = $item.ToCharArray()

        $Array = @()

        foreach ($char in $characters) {
            $int = [int][char]$char
            if ($int -ge 65 -and $int -le 90) {
                $Array += "[$([char][int]$($int+32))$char]"
            } elseif ($int -ge 97 -and $int -le 122) {
                $Array += "[$char$([char][int]$($int-32))]"
            } elseif ($int = 46) {
                $Array += "\."
            } elseif ($int = 32) {
                $Array += "\s"   
            } else {
                $Array += $char
            }
        }

        [string]$Regex = $Array -join ''
        $WordinRegex += $Regex
    }

    if ($Or) {
        return $WordinRegex -join '|'
    } else {
        return $WordinRegex
    }

}