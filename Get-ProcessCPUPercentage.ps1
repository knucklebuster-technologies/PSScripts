function Get-ProcessCPUPercentage {
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
    [System.Diagnostics.Process]
    $Process
    )

    begin {}

    process {
        $CookedValue = get-counter -Counter "\Process($($Process.Name))\% processor time" -EA SilentlyContinue | 
        select -ExpandProperty countersamples -EA SilentlyContinue | 
        select -ExpandProperty cookedvalue -EA SilentlyContinue
        $CPUPercentage = [Math]::Round($( $CookedValue / $env:NUMBER_OF_PROCESSORS ))
        Add-Member -InputObject $Process -MemberType NoteProperty -Name 'CPUPercentage' -Value $CPUPercentage -Force -PassThru
    }

    end {}
}