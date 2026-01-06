#!/bin/sh

ollama serve &

echo "Waiting for Ollama to start..."
until curl -s http://localhost:11434/api/tags > /dev/null; do
  sleep 1
done
echo "Ollama is up and running."
ollama pull tinydolphin
 
until curl -s http://localhost:11434/api/models/tinydolphin > /dev/null; do
  sleep 2
done
echo "Model tinydolphin is loaded."
python cli.py run \
  --questions questions.txt \
  --persona persona.json \
  --model tinydolphin \
  --num-responses 100 \
  --output results.csv \
  --temperature 1.0 \
  --response-options "Never,Rarely,Sometimes,Often,Always"
if [ $? -ne 0 ]; then
  echo "Error: Survey response generation failed."
  exit 1
fi

echo "Survey responses have been generated and saved to results.csv."