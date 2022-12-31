#Change all the network card to private
$Return = Set-NetConnectionProfile -Name * -NetworkCategory Private
#Ebable PS Remoting
$Return = Enable-PSRemoting –force
#Change WinRM service start mode to automatic
$Return = Start-Job -ScriptBlock{cmd /c "sc config WinRM start=auto"}
#Enable WinRM in local firewall
$Return = netsh advfirewall firewall add rule name="Windows Remote Management (HTTP-In)" dir=in action=allow service=any enable=yes profile=any localport=5985 protocol=tcp
if ( $((Get-WMIObject win32_operatingsystem).name) -match "Microsoft Windows Server 2016*" ) {
    $Return = New-NetFirewallRule -Direction Inbound -DisplayName "mDNS (UDP-In)" -Group "mDNS" -Profile Private -Enabled True -Action Allow -Program "%SystemRoot%\system32\svchost.exe" -RemoteAddress "LocalSubnet" -Protocol "UDP" -LocalPort "5353"
}
#Disable limit blank password use
$Return = Set-ItemProperty -Path 'REGISTRY::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa' -Name 'LimitBlankPasswordUse' -Value 0 -force

Add-Type -AssemblyName PresentationFramework
$Return = [System.Windows.MessageBox]::Show('The computer is setup and ready for remote restart\stop. :-)','Success')