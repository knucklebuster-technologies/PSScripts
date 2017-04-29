function Register-ProcessorUsageEvent {
    [CmdletBinding()]
    param(
    [Parameter(Position=0)]
    [ValidateRange(0,100)]
    [int]
    $MaxPercentUsed=85
    )

    $WQL = "SELECT * from __InstanceModificationEvent WITHIN 45 WHERE TargetInstance ISA 'Win32_Processor' and TargetInstance.LoadPercentage > $MaxPercentUsed"
    Register-WmiEvent -Query "$WQL" -SourceIdentifier 'CPU Usage Event' -Action {
        $TimeGenerated = $event.TimeGenerated
        $CurrentLoadPercentage = $event.SourceArgs.NewEvent.TargetInstance.LoadPercentage
        $PreviousLoadPercentage = $event.SourceArgs.NewEvent.PreviousInstance.LoadPercentage
        
		$PerfLog.Info("CPU Load Percentage Event Raised -`t $TimeGenerated", $MyInvocation.MyCommand)
		$PerfLog.Info("The Current Load Percentage -`t`t $CurrentLoadPercentage", $MyInvocation.MyCommand)
		$PerfLog.Info("The Previous Load Percentage -`t`t $PreviousLoadPercentage", $MyInvocation.MyCommand)
		$PerfLog.Info("", $MyInvocation.MyCommand)
		[FP.Automation.BootStrapping.General.ProcessPercentCpuUsed]::GetCpuPerProcessList() | 
		ForEach-Object { 
			$PerfLog.Info("Id: $($_.Id) Name: $($_.Name) CPUPercent: $($_.PercentCpuUsed)", "CPU Usage Event")
		}
    }
}