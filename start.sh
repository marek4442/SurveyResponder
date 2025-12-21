#!/bin/sh

ollama serve &

echo "Waiting for Ollama to start..."
until curl -s http://localhost:11434/api/tags > /dev/null; do
  sleep 1
done
echo "Ollama is up and running."
ollama pull llama3.1:latest

python SurveyResponder.py run