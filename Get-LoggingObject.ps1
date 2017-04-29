
function Get-LoggingObject {
	param (
		$Name = 'Automation.General.LoggerObject',
		$Directory = $( Get-Location )
	)
	
    #new dynamic object
    $Logger = New-Object PSObject
	
    #add properties
    $Logger | Add-Member -MemberType NoteProperty -Name 'Name' -Value $Name -Force
    $Logger | Add-Member -MemberType NoteProperty -Name 'Folder' -Value $Directory -Force
    $Logger | Add-Member -MemberType ScriptProperty -Name 'FullName' -Value { 
        Join-Path -Path $this.Folder -ChildPath "$( $this.Name ).log.txt" 
    } -Force
	
    #add info method
    $Logger | Add-Member -MemberType ScriptMethod -Name 'Info' -Value {
		param (
            $Message = 'Empty Message',
			$Context = 'Logger'
		)

		"$( Get-Date -Format 'MM-dd-yyyy HH:mm:ss' ) INFO $( $this.Name ) [$Context] - $Message" |
		Add-Content -Path $this.FullName -Force -PassThru |
		Write-Host -ForegroundColor White
	} -Force
	
    #add warn method
    $Logger | Add-Member -MemberType ScriptMethod -Name 'Warn' -Value {
		param (
            $Message = 'Empty Message',
			$Context = 'Logger'
		)

		$Msg = "$( Get-Date -Format 'MM-dd-yyyy HH:mm:ss' ) WARN $( $this.Name ) [$Context] - $Message" |
		Add-Content -Path $this.FullName -Force -PassThru |
        Where-Object { "$( Get-Variable 'WarningPreference' -Scope 1 -ValueOnly )" -ne 'SilentlyContinue' } |
		Write-Host -ForegroundColor Yellow
	} -Force
	
    #add error method
    $Logger | Add-Member -MemberType ScriptMethod -Name 'Error' -Value {
		param (
            $Message = 'Empty Message',
			$Context = 'Logger'
		)

		$Msg = "$( Get-Date -Format 'MM-dd-yyyy HH:mm:ss' ) ERROR $( $this.Name ) [$Context] - $Message" |
		Add-Content -Path $this.FullName -Force -PassThru |
        Where-Object { "$( Get-Variable 'ErrorActionPreference' -Scope 1 -ValueOnly )" -ne 'SilentlyContinue' } |
		Write-Host -ForegroundColor Red
	} -Force
	
    #add debug method
    $Logger | Add-Member -MemberType ScriptMethod -Name 'Debug' -Value {
		param (
            $Message = 'Empty Message',
			$Context = 'Logger'
		)

		$Msg = "$( Get-Date -Format 'MM-dd-yyyy HH:mm:ss' ) DEBUG $( $this.Name ) [$Context] - $Message" |
		Add-Content -Path $this.FullName -Force -PassThru |
        Where-Object { "$( Get-Variable 'DebugPreference' -Scope 1 -ValueOnly )" -ne 'SilentlyContinue' } |
		Write-Host -ForegroundColor Green
	} -Force
	
    #add verbose method
    $Logger | Add-Member -MemberType ScriptMethod -Name 'Verbose' -Value {
		param (
            $Message = 'Empty Message',
			$Context = 'Logger'
		)

		$Msg = "$( Get-Date -Format 'MM-dd-yyyy HH:mm:ss' ) VERBOSE $( $this.Name ) [$Context] - $Message" |
		Add-Content -Path $this.FullName -Force -PassThru |
        Where-Object { "$( Get-Variable 'VerbosePreference' -Scope 1 -ValueOnly )" -ne 'SilentlyContinue' } |
		Write-Host -ForegroundColor Cyan
	} -Force
	
    #clear log if already exists
	if( Test-Path ( $Logger.FullName )) {
		Clear-Content -Path ( $Logger.FullName ) -Force
	}
	
	$Logger | Write-Output
}