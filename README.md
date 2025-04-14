# FI - Teste Prático

Este projeto foi desenvolvido como parte de um teste técnico para vaga de desenvolvedor .NET.

## 🛠 Tecnologias Utilizadas

- ASP.NET MVC (.NET Framework 4.8)
- C#
- SQL Server (LocalDB)
- Entity Framework (ADO.NET)
- Visual Studio 2022

## 📋 Funcionalidades

- Cadastro de clientes com validação de CPF
- Edição de dados do cliente
- Cadastro e gerenciamento de beneficiários vinculados a um cliente
- Validações de formulário
- Modal para adicionar/excluir beneficiários
- Gravação e persistência de dados no banco

## ⚙️ Como executar o projeto

1. Clone o repositório ou baixe os arquivos
2. Abra o projeto `FI.AtividadeEntrevista.sln` com o **Visual Studio 2022**
3. Restaure os pacotes NuGet automaticamente
4. Verifique se o LocalDB está instalado (padrão do Visual Studio)
5. Execute o projeto (F5)
6. O banco será criado automaticamente na primeira execução

## 📦 Banco de Dados

O projeto utiliza **SQL Server LocalDB** e cria automaticamente a base necessária com as tabelas:

- CLIENTES
- BENEFICIARIOS

Caso deseje, você pode visualizar a base usando o **SQL Server Management Studio** conectado ao LocalDB.

## 💡 Observações

- O campo CPF é validado tanto no front quanto no back-end.
- Os beneficiários são vinculados a um cliente através da tabela BENEFICIARIOS.
- Beneficiários são exibidos em uma modal de forma dinâmica.

---

## 🧠 Desenvolvedor

**Juninho**  
Email: junior.cobol@gmail.com

