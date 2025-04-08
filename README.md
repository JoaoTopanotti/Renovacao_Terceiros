<h1 align="center">Renovação de Terceiros</h1>



<div align="center">
  <strong>🚀 Descrição do Repositório 📚</strong>
</div>

<div align="center">
  <p>Repositório da automação de renovação de terceiros no Active Directory! 🎉</p>
  <p>Utilizado 2 scripts em PowerShell para encontrar terceiros a renovar (terceiro_renovacao.ps1) e de atualização de conta no AD (renovaTerceiro_AD.ps1) que trabalhando juntamente com o ShrePoint e PowerAutomate deixa o processo totalmente automático.</p>
</div>

## 📖 Índice

- [Visão Geral](#visão-geral)
- [Tecnologias](#tecnologias)
- [Configuração do Ambiente](#configuração-do-ambiente)
- [Contribuição](#Contribuição)

## 🔭 Visão Geral

Projeto para renovar contas com expiração no AD (Terceiros), enviando e-mail para os gestores responsáveis, e em integração com PowerAutomate atualiza dados da conta reabilitando-a.

## 💻 Tecnologias

- PowerShell 5.0+
- Agendador de tarefas
- PowerAutomate
- Forms (Sharepoint)

## ⚙️ Configuração do Ambiente

1º Passo:
    Agendar o script "terceiro_renovacao.ps1" no agendador de tarefas do Windows Server (recomendado 1 vez ao dia);

2º Passo:
    Criação do Forms no Sharepoint, o mesmo deve conter campos que estejam sincronizados com as variáveis do script "RenovaTerceiro_AD.ps1";

3º Passo:
    Quando preenchido forms com informações válidas, executa o script "RenovaTerceiro_AD.ps1" (agendamento via PowerAutomate);

4º Passo:
    Criar uma regra de envio de e-mail para o gestor responsável em caso de renovação e em caso de retornar para adicionar informações adicionais.

## 📝 Contribuição

Se você deseja contribuir com melhorias para o projeto, siga as etapas abaixo:

1. Faça um fork do repositório e clone-o em sua máquina.
2. Crie uma nova branch para suas modificações.
3. Faça as alterações necessárias e adicione-as ao stage.
4. Envie um pull request para que suas modificações sejam revisadas.

Ficaremos felizes em receber suas contribuições!

✨ Divirta-se explorando e personalizando o Projeto de Exemplo! Se tiver alguma dúvida ou precisar de suporte, fique à vontade para entrar em contato. Aproveite! ✨
