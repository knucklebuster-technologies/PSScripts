$sVMDK = 'C:\VM\VMDK\AVM-TA-CLI00.vmdk'
$tVMDK = 'C:\VM\VMDK\AVM-TA-CLI01.vmdk'
$tVHDX = 'C:\VM\VHDX\AVM-TA-CLI01.vhd'

#convert single VMDK to multi files
Push-Location -Path 'C:\Program Files (x86)\VMware\VMware Virtual Disk Development Kit\bin'
.\vmware-vdiskmanager.exe -r $sVMDK -t 1 $tVMDK
Pop-Location

#convert VMDK to VHD
Push-Location -Path 'C:\Program Files (x86)\Microsoft Virtual Machine Converter Solution Accelerator'
.\MVDC.exe $tVMDK $tVHDX
Pop-Location