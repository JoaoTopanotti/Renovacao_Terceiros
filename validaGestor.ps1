param (
    [Parameter(Mandatory=$true)]
    [string]$EmailGestor,

    [Parameter(Mandatory=$true)]
    [string]$LoginTerceiro
)

Import-Module ActiveDirectory

# Procurar o usuário terceiro
$terceiro = Get-ADUser -Filter { SamAccountName -eq $LoginTerceiro } -Properties Manager
if (!$terceiro) {
    Write-Output "false"
    exit
}

# Agora procurar o gestor no AD, com base no e-mail
$gestor = Get-ADUser -Filter { Mail -eq $EmailGestor } -Properties DistinguishedName

if (!$gestor) {
    Write-Output "false"
    exit
}

# Compara se o Manager do terceiro é o Gestor
if ($terceiro.Manager -eq $gestor.DistinguishedName) {
    Write-Output "true"
} else {
    Write-Output "false"
}