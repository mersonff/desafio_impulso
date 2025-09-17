#!/bin/bash

# Script para compilar assets para produção
set -e

echo "🎨 Compilando assets para produção..."

# Instalar dependências se necessário
if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependências JS..."
    yarn install --frozen-lockfile
fi

# Compilar CSS com Sass e PostCSS
echo "🎨 Compilando SCSS para CSS..."
yarn build:css

# Verificar se o arquivo CSS foi gerado
if [ ! -f "app/assets/builds/application.css" ]; then
    echo "❌ Erro: app/assets/builds/application.css não foi gerado!"
    exit 1
fi

echo "✅ CSS compilado com sucesso!"

# Precompilar assets do Rails
echo "🏗️ Precompilando assets do Rails..."
RAILS_ENV=production SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# Verificar se assets foram compilados
if [ ! -d "public/assets" ]; then
    echo "❌ Erro: Assets não foram precompilados!"
    exit 1
fi

echo "✅ Assets precompilados com sucesso!"

# Limpar arquivos temporários
echo "🧹 Limpando arquivos temporários..."
rm -rf tmp/cache/assets

echo "🎉 Build de assets concluído!"