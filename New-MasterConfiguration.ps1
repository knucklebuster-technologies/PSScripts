$Machines = @{
    'EVM-VC-CLI00'='10.234.176.4'
    'EVM-VC-PLI00'='10.234.176.2'
    'EVM-VC-CLI10'='10.234.177.4'
    'EVM-VC-PLI10'='10.234.177.2'
    'EVM-VC-CLI20'='10.234.178.4'
    'EVM-VC-PLI20'='10.234.178.2'
    'EVM-VC-SVR00'='10.244.86.102'
    'EVM-VC-TRA00'='10.242.90.10'
}

$Clients = @()
$Porchlights = @()
$Servers = @()
$Transports = @()

function New-ClientDefined {
    param(
    $ComputerName,
    $IPAddress,
    $Pop,
    $Instance
    )

    return @"
    <Client IPAddress='$IPAddress' Description='Client'>
      <Pop Value='$Pop' />
      <Instance Value='$Instance' />
      <ComputerName Value='$ComputerName' />
      <OperatingSystem Value='Windows 7' />
      <Username Value='labuser' />
      <PublicIP Value='$IPAddress' />
    </Client>
"@
}

function New-PorchlightDefined {
    param(
    $ComputerName,
    $IPAddress,
    $Pop,
    $Instance
    )

    return @"
    <PorchLight IPAddress='$IPAddress' Description='POP 0 PorchLight'>
      <Pop Value='$Pop' />
      <Instance Value='$Instance' />
      <ComputerName Value='$ComputerName' />
      <Username Value='locallabuser' />
      <Release Value='7.0' />
      <IsPrimary Value='True' />
      <Group Value='0' />
      <Message Value='True' />
      <Monitor Value='True' />
      <CommIPv4 Value='$IPAddress' />
      <MgtIPAddress Value='$IPAddress' />
    </PorchLight>
"@
}

function New-ServerDefined {
    param(
    $ComputerName,
    $IPAddress,
    $Pop,
    $Instance
    )

    return @"
    <Server IPAddress='$IPAddress' Description='IPv4 FPServer Host'>
      <ServerType Value='IPv4 Server' />
      <Instance Value='$Instance' />
      <Username Value='labuser' />
    </Server>
"@
}

function New-TransportDefined {
    param(
    $ComputerName,
    $IPAddress,
    $Pop,
    $Instance
    )

    return @"
    <Transport IPAddress='$IPAddress' Description='Transport'>
      <VPNAddress Value='$IPAddress' />
      <Instance Value='$IPAddress' />
      <ComputerName Value='$ComputerName' />
      <Username Value='labuser' />
    </Transport>
"@
}

ForEach($entry in $( $Machines.GetEnumerator() )) {
    
    $computerName = "$( $entry.Key )"
    $ipAddress = "$( $entry.Value )"
    $pop = $computerName[-2]
    $instance = $computerName[-1]
    switch( $computerName.Substring(7,3) ) {
        'PLI' {
            $porchlight = New-PorchlightDefined -ComputerName $computerName -IPAddress $ipAddress
            $Porchlights+=$porchlight
        }
        'CLI' {
            $client = New-ClientDefined -ComputerName $computerName -IPAddress $ipAddress
            $Clients+=$client
        }
        'SRV' {
            $server = New-ServerDefined -ComputerName $computerName -IPAddress $ipAddress
            $Servers+=$server
        }
        'TRA' {
            $transport = New-TransportDefined -ComputerName $computerName -IPAddress $ipAddress
            $Transports+=$transport
        }
    }
}

[xml] $MaterXML = @"
<?xml version='1.0'?>
<TestLab Version='3.0'>
  <variable Name='Environment_Configuration' Value='' />
  <variable Name="Backup_PATH" Value="\\10.240.0.5\xxx\x\Backup" Description="Backup Path" />
  <Clients>
    $( $Clients )
  </Clients>
  <PorchLights>
    $( $Porchlights )
  </PorchLights>
  <Servers>
    $( $Servers )
  </Servers>
  <Transports>
    $( $Transports )
  </Transports>
</TestLab>
"@

$MaterXML.Save("C:\Testing\Configurations\TestMaster.xml")