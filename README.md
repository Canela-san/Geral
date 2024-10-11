# WinSysFlow

**WinSysFlow** é um script em PowerShell projetado para automatizar diversas tarefas de manutenção e otimização no Windows. Com uma interface simples e fácil de usar, ele permite que os usuários realizem tarefas como desfragmentação de disco, verificação de saúde do sistema, execução de antivírus, alteração de planos de energia, entre outras funções essenciais. Tudo isso pode ser programado para ser executado de forma sequencial, proporcionando uma gestão eficiente de tempo e recursos.

## Funcionalidades

- **Desfragmentação de Disco**: Realiza a desfragmentação dos discos para melhorar a performance do sistema.
- **Verificação de Saúde do Sistema**: Executa verificações de integridade e relata possíveis problemas encontrados.
- **Execução de Antivírus**: Permite rodar uma verificação completa ou personalizada com o antivírus instalado.
- **Gestão de Planos de Energia**: Modifica rapidamente o plano de energia, permitindo ajustes automáticos conforme a necessidade.
- **Programação de Tarefas Consecutivas**: Permite a automação de tarefas em sequência, como desfragmentação seguida de antivírus e desligamento.
- **Geração de Logs Detalhados**: Registra o progresso de cada etapa, com logs informativos sobre cada ação executada.

## Como Usar

### Pré-requisitos

- **Windows PowerShell**: Certifique-se de estar utilizando o PowerShell 5.0 ou superior.
- **Permissão de Execução de Scripts**: Pode ser necessário permitir a execução de scripts no PowerShell. Para isso, rode o comando abaixo como Administrador:

  ```powershell
  Set-ExecutionPolicy RemoteSigned

## Instalação

Clone o repositório para o seu computador local:

  ```powershell
  git clone https://github.com/seuusuario/winsysflow.git
  ```

Navegue até o diretório do projeto:

  ```powershell
  cd winsysflow
  ```
Execute o script PowerShell:

  ```powershell
  ./WinSysFlow.ps1
  ```

## Utilização

Após iniciar o script, você será guiado através de um menu interativo que permitirá escolher quais tarefas deseja realizar. Você também pode programar várias tarefas para serem executadas consecutivamente. Ao final de cada tarefa, será gerado um log detalhado no diretório especificado.
Exemplo de Uso

Para executar uma sequência de tarefas (desfragmentar, rodar o antivírus e desligar o computador):

  ```powershell
  Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File ./WinSysFlow.ps1 -tasks defrag, antivirus, shutdown"
  ```
## Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests para sugerir melhorias ou correções.
Como Contribuir

    Faça um fork do projeto
    Crie um branch para a sua feature/correção (git checkout -b feature/nova-feature)
    Commit suas alterações (git commit -m 'Adiciona nova feature')
    Dê um push para o branch (git push origin feature/nova-feature)
    Abra um pull request

Licença

Este projeto está licenciado sob a licença MIT. Para mais informações, consulte o arquivo LICENSE.
Contato

Se você tiver qualquer dúvida ou sugestão, sinta-se à vontade para entrar em contato através do e-mail: Gabriel.Canela.TI@gmail.com
