function Get-BarNight{
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$BarNightFile
    )
    BEGIN{
        Write-Verbose "[$(Get-Date)] $($MyInvocation.MyCommand) has started"
        if(Test-Path $BarNightFile){
            Write-Verbose "Setting variables"
            $ContentsBars = Get-Content $BarNightFile
            $location = Get-Location
            $flag = $true
        }
        else{
            Write-Error "$BarNightFile is not a valid file."
            exit
        }
    }
    PROCESS{
        do{
            Write-Verbose "Getting random bar from $BarNightFile"
            $bar = Get-Random -InputObject $ContentsBars
            if(Test-Path "$location\RecentBars.txt"){
                Write-Verbose "Getting recent bar night locations"
                $ContentsRecent = Get-Content "$location\RecentBars.txt"
                if($ContentsRecent -contains $bar){
                    Write-Verbose "Bar night was already held at $bar in the last five(5) weeks"
                } else{
                    Write-Verbose "Updating file holding recent bars"
                    Add-Content "$location\RecentBars.txt" "$bar"
                    if($ContentsRecent.Count -ge 5){
                        Get-Content "$location\RecentBars.txt" | Select-Object -Skip 1 | Set-Content "$location\RecentBars-temp.txt"
                        Move-Item "$location\RecentBars-temp.txt" "$location\RecentBars.txt" -Force
                    }
                    break
                }
            } else{
                Write-Verbose "Creating $location\RecentBars.txt"
                New-Item -Path "$location\RecentBars.txt" -ItemType File -Force | Out-Null
                Set-Content -Path "$location\RecentBars.txt" -Value "$bar"
                break
            }
        } while ($flag)
    }
    END{
        Write-Verbose "[$(Get-Date)] $($MyInvocation.MyCommand) has started"
        Write-Output $bar
    }
}