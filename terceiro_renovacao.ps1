Import-Module ActiveDirectory

# Dias para mandar e-mail 
$dateToday = Get-Date
$alertDays = @(1..30)

# Configuração do servidor SMTP 
$smtpServer = "smtp.office365.com"
$smtpPort = 587
$from = "notificati@fs.agr.br"
$password = "2q:WO4I.3Uc5|/V"
$userName = "notificati@fs.agr.br"
$subject = "Renovação de Acesso Rede FS - Terceiros"
$subject2 = "Renovação de Acesso Rede FS - Terceiros (sem gestor)"
$defaultTo = "denis.henrique@fs.agr.br"
$cc = "deividy.machado@fs.agr.br"

# Coleta todos os usuários com contas expirando nos próximos 30 dias
$users = @()
foreach ($days in $alertDays) {
    $targetDate = $dateToday.AddDays($days).Date
    $users += Get-ADUser -Filter {
        Enabled -eq $true -and accountExpires -ne 0 -and accountExpires -ne 9223372036854775807
    } -Property DisplayName, accountExpires, mail, company, Manager | Where-Object {
        [datetime]::FromFileTime($_.accountExpires).Date -eq $targetDate
    }
}

# Agrupa usuários por gestor, incluindo usuários sem gestor
$usersByManager = $users | Group-Object -Property {
    if ($_.Manager -ne $null) {
        $_.Manager
    } else {
        "NoManager"
    }
}

# Envia os e-mails por gestor
foreach ($group in $usersByManager) {
    $managerDN = $group.Name

    # Verifica se o gestor existe
    if ($managerDN -eq "NoManager") {
        $managerEmail = $defaultTo
        $emailSubject = $subject2
        $managerDisplayName = "Equipe Responsável"
    } else {
        try {
            $manager = Get-ADUser -Identity $managerDN -Property mail, DisplayName
            $managerEmail = $manager.mail
            $emailSubject = $subject
            $managerDisplayName = $manager.DisplayName
        } catch {
            # Caso o gestor não seja encontrado, use o destinatário padrão
            $managerEmail = $defaultTo
            $emailSubject = $subject2
            $managerDisplayName = "Equipe Responsável"
        }
    }

    # Monta a tabela HTML consolidada para todos os usuários do gestor
    $tableRows = $group.Group | ForEach-Object {
        $expirationDate = [datetime]::FromFileTime($_.accountExpires).ToString("dd/MM/yyyy")
        "<tr><td>$($_.DisplayName)</td><td>$($_.Company)</td><td>$expirationDate</td></tr>"
    }

    $table = @"
<table border="1" style="border-collapse: collapse; width: 100%;">
    <thead>
        <tr>
            <th style="padding: 8px; text-align: left; background-color: #f2f2f2;">Usuário</th>
            <th style="padding: 8px; text-align: left; background-color: #f2f2f2;">Empresa</th>
            <th style="padding: 8px; text-align: left; background-color: #f2f2f2;">Data de Expiração</th>
        </tr>
    </thead>
    <tbody>
        $tableRows
    </tbody>
</table>
"@

    # Corpo do e-mail em HTML
    $body = @"
<html>
<body>
<p>Prezado(a) $managerDisplayName,</p>
<p>A conta de rede FS dos seguintes usuários expira em breve:</p>
$table
<p>Caso seja necessário renovação, favor providenciar através do: <a href="https://vfb1smp.global.local:50001/sap/bc/ui2/flp#Shell-home">ITSM</a></p>
<p>Atenciosamente,<br>
Equipe de TI</p>
<img src="https://fsportal.dimo.com.br/assets/images/logo1.png" width="300" height="150">
</body>
</html>
"@

    # Configuração e envio do e-mail
    $mail = New-Object System.Net.Mail.MailMessage
    $mail.From = $from
    $mail.To.Add($defaultTo)
    $mail.CC.Add($cc)
    $mail.Subject = $emailSubject
    $mail.SubjectEncoding = [System.Text.Encoding]::UTF8
    $htmlView = [System.Net.Mail.AlternateView]::CreateAlternateViewFromString($body, [System.Text.Encoding]::UTF8, "text/html")
    $mail.AlternateViews.Add($htmlView)

    # Configuração do cliente SMTP
    $smtp = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort)
    $smtp.EnableSsl = $true
    $smtp.Credentials = New-Object System.Net.NetworkCredential($userName, $password)
    $smtp.Timeout = 300000

    try {
        $smtp.Send($mail)
        Write-Host "E-mail enviado para $managerEmail." -ForegroundColor Green
    } catch {
        Write-Host "Erro ao enviar e-mail para $managerEmail $_.Exception.Message" -ForegroundColor Red
    }
}
