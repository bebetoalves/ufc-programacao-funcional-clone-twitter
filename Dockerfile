FROM elixir:latest

# Instala Node.js 14.20.0
RUN curl -sL https://nodejs.org/dist/v14.20.0/node-v14.20.0-linux-x64.tar.xz -o node.tar.xz && \
    tar -xJf node.tar.xz -C /usr/local --strip-components=1 && rm node.tar.xz

# Define o diretório de trabalho
WORKDIR /app

# Copia todo o conteúdo do projeto para dentro do container
COPY . .

# Instala as dependências locais do Mix
RUN mix local.hex --force && mix local.rebar --force

# Desinstala os arquivos de phx_new e hex (se existirem) e instala o phx_new 1.5.7
RUN mix archive.uninstall phx_new || true && \
    mix archive.uninstall hex || true && \
    mix archive.install hex phx_new 1.5.7 --force

# Busca e compila as dependências do projeto
RUN mix deps.get && mix deps.compile && mix compile

# Se existir o diretório "assets" com package.json, instala as dependências do Node e gera os assets
RUN if [ -d "assets" ] && [ -f "assets/package.json" ]; then \
      cd assets && npm install && npm run deploy && cd .. && mix phx.digest; \
    fi

# Expõe a porta padrão do Phoenix
EXPOSE 4000

# Inicia o servidor Phoenix
CMD ["mix", "phx.server"]
