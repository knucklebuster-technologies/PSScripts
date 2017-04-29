function New-ObservableCollection {
    Param (
    [string]
    $TypeName,
    [ScriptBlock]
    $AddAction,
    [ScriptBlock]
    $RemoveAction
    )
    $observable = New-Object System.Collections.ObjectModel.ObservableCollection[$TypeName]
    $eventSub = Register-ObjectEvent -InputObject $observable -EventName CollectionChanged -Action { 
        if($Event.SourceEventArgs.Action -eq 'Add') {
            $Event.SourceEventArgs.NewItems |
            ForEach-Object {
                Write-Host $_
                $Event.Sender.Remove($_) | Out-Null
            }
        }
    }
}