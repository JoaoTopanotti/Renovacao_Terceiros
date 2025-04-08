Import-Module ActiveDirectory

param (
    [string]$SamAccountName,
    [string]$Name,
    [string]$Email,
    [string]$EmployeeNumber,
    [string]$Phone,
    [string]$Title,
    [string]$Description,
    [string]$ManagerEmail,
    [string]$ExpirationAccount
)

# Buscar o usuário
$user = Get-ADUser -Filter "SamAccountName -eq '$SamAccountName'" -Properties *
if ($null -eq $user) { exit 1 }

# Buscar o manager pelo e-mail
$manager = Get-ADUser -Filter "Mail -eq '$ManagerEmail'" -Properties Mail
if ($null -eq $manager) { exit 1 }

# Atualiza usuário
try {
    Set-ADUser -Identity $user.DistinguishedName `
        -DisplayName $Name `
        -EmailAddress $Email `
        -EmployeeNumber $EmployeeNumber `
        -OfficePhone $Phone `
        -Title $Title `
        -Description $Description `
        -Manager $manager.DistinguishedName
    Enable-ADAccount -Identity $user.DistinguishedName
}
catch {
    # Write-Error "$_"
    exit 1
}

# Define data de expiração
if ($ExpirationAccount) {
    try {
        $expirationDate = [datetime]::ParseExact($ExpirationAccount, 'yyyy-MM-dd', $null)
        Set-ADAccountExpiration -Identity $user.DistinguishedName -DateTime $expirationDate
    }
    catch {
        # Write-Error "$_"
        exit 1
    }
}