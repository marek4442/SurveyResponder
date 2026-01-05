#!/bin/sh

ollama serve &

echo "Waiting for Ollama to start..."
until curl -s http://localhost:11434/api/tags > /dev/null; do
  sleep 1
done
echo "Ollama is up and running."
ollama pull llama3.1:latest

python cli.py run \
  --questions questions.txt \
  --persona persona.json \
  --model llava-llama3:latest \
  --num-responses 100 \
  --output results.csv \
  --temperature 1.0 \
  --response-options "Never,Rarely,Sometimes,Often,Always"
echo "Survey responses have been generated and saved to results.csv."