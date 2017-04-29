get-childitem . -include *.sln -recurse |   
ForEach-Object {   
    $file = $_
    $inVCSection = $False  
    get-content $file |   
    ForEach-Object {   
        $line = $_.Trim();   
        if ($inVCSection -eq $False -and $line.StartsWith('GlobalSection') -eq $True -and $line.Contains('VersionControl') -eq $True) {   
            $inVCSection = $True   
        }   
        if ($inVCSection -eq $False) {   
            add-content ($file.fullname + '.new') $_   
        }   
        if ($inVCSection -eq $True -and $line -eq 'EndGlobalSection') {   
            $inVCSection = $False  
        }  
    }  
    MV ($file.fullname + '.new') $file.fullname -force   
}  

# Remove the bindings from the csproj files  
get-childitem . -include *.csproj -recurse |   
ForEach-Object {   
    $file = $_   
    get-content $file |   
    ForEach-Object{   
        $line = $_.Trim();   
        if ($line.StartsWith('<Scc') -eq $False) {  
            add-content ($file.fullname + '.new') $_   
        }  
    }
}  
mv ($file.fullname + '.new') $file.fullname -force   
