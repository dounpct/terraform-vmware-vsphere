$vcenter=$args[0]
$user=$args[1]
$password=$args[2]
$filter_subnet=$args[3]
$std_out_file=$args[4]

Set-PowerCLIConfiguration -ProxyPolicy NoProxy -Scope Session -confirm:$false
Set-PowerCLIConfiguration -ParticipateInCeip $false -confirm:$false
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -confirm:$false

Connect-VIServer -Server $vcenter -Protocol https -User $user -Password $password

Get-VM | Select @{N="IP-ADDR";E={@($_.guest.IPAddress -like "${filter_subnet}" -join "|")}} | grep ${filter_subnet} > $std_out_file