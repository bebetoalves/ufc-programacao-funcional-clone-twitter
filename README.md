# UFC Russas - Programação Funcional - Clone Twitter

Construção de uma aplicação web MVC usando a linguagem Elixir/framework Phoenix.

Construir uma aplicação totalmente dentro do paradigma funcional, onde haverá usuários autenticados e controle de seções. A app web deve acompanhado de recursos básicos semelhantes ao Twitter.

## Tecnologias Utilizadas

1. Docker
2. Elixir
3. Phoenix
4. TailwindCSS

## Operações Suportadas

1. Criação de conta.
2. Login.
3. Seguir usuário.
4. Buscar usuário.
5. Timeline.
6. Perfil do Usuário.
7. Curtir/Descurtir, Apagar e Retweetar.

## Instalação

O projeto possui o Docker para facilitar a instalação do projeto, se você já tem ele instalado, rode o comando abaixo:

```sh
docker compose up -d
```

Depois, é necessário rodar as migrations:

```sh
docker compose exec web mix ecto.migrate
``` 

Após, acesse [https://localhost:4000](https://localhost:4000) para ter acesso a página inicial.
