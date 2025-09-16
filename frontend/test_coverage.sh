#!/bin/bash

# Script para executar testes com coverage

echo "🧪 Executando testes com coverage..."

# Limpa coverage anterior
flutter clean
flutter pub get

# Executa testes com coverage
flutter test --coverage

# Verifica se o coverage foi gerado
if [ -f coverage/lcov.info ]; then
    echo "✅ Coverage gerado com sucesso!"
    
    # Gera relatório HTML (opcional, requer lcov)
    if command -v genhtml &> /dev/null; then
        echo "📊 Gerando relatório HTML..."
        genhtml coverage/lcov.info -o coverage/html
        echo "🌐 Relatório HTML gerado em: coverage/html/index.html"
    else
        echo "💡 Para gerar relatório HTML, instale lcov:"
        echo "   - Ubuntu/Debian: sudo apt-get install lcov"
        echo "   - macOS: brew install lcov"
    fi
    
    # Mostra resumo do coverage
    echo ""
    echo "📈 Resumo do Coverage:"
    if command -v lcov &> /dev/null; then
        lcov --summary coverage/lcov.info
    else
        echo "Para ver resumo detalhado, instale lcov"
    fi
    
else
    echo "❌ Erro ao gerar coverage"
    exit 1
fi

echo ""
echo "🎯 Coverage completo! Verifique o arquivo coverage/lcov.info"
