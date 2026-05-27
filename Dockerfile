# Estágio 1: Build da aplicação Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS build-env

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia os arquivos do projeto para o container
COPY . .

# Resolve as dependências do projeto
RUN flutter pub get

# Realiza o build da aplicação web para produção
RUN flutter build web

# Estágio 2: Configuração do servidor Nginx para servir a aplicação web
FROM nginx:alpine

# Copia a configuração personalizada do Nginx para suportar as rotas do Flutter
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia a pasta compilada do estágio anterior para a pasta padrão do nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

# O Nginx escuta na porta 80 por padrão
EXPOSE 80

# Inicia o servidor web Nginx em primeiro plano
CMD ["nginx", "-g", "daemon off;"]
