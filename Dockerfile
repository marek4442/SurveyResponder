FROM python:3.12-slim AS builder



WORKDIR /app

RUN apt-get update && \
 apt-get install --no-install-recommends -y curl ca-certificates build-essential && \
 rm -rf /var/lib/apt/lists/*

ARG ADAM_COMMIT=99f71a46e98d5f92e6cd28c25e145afbbbc11e84
ARG MAREK_COMMIT=4a096e9b7f66b8aa106ebaab18f3b9464d9b2d84
ARG ADAM_URL=https://raw.githubusercontent.com/adamrossnelson/SurveyResponder/${ADAM_COMMIT}
ARG MAREK_URL=https://raw.githubusercontent.com/marek4442/SurveyResponder/${MAREK_COMMIT}

RUN curl -fsSL ${ADAM_URL}/SurveyResponder.py -o SurveyResponder.py && \
  curl -fsSL ${ADAM_URL}/requirements.txt -o requirements.txt && \
  curl -fsSL ${ADAM_URL}/persona.json -o persona.json && \
  curl -fsSL ${ADAM_URL}/questions.txt -o questions.txt && \
  curl -fsSL ${ADAM_URL}/cli.py -o cli.py && \
  curl -fsSL ${MAREK_URL}/start.sh -o start.sh


RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir aiohttp && \
  pip install --no-cache-dir psutil

RUN chmod +x start.sh

FROM python:3.12-slim
ARG TARGETARCH
ARG TARGETOS

RUN apt-get update && \
     apt-get install --no-install-recommends -y curl ca-certificates && \
     rm -rf /var/lib/apt/lists/*

RUN useradd -m appuser && \
    mkdir -p /app && \
    chown -R appuser:appuser /app

COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /app  /app

WORKDIR /app
RUN curl -fsSL https://ollama.ai/install.sh -o install.sh && \
    echo "9f5f4c4ed21821ba9b847bf3607ae75452283276cd8f52d2f2b38ea9f27af344 install.sh" | sha256sum --check && \
    sh install.sh && \
    rm install.sh && \
    chown -R appuser:appuser /usr/local/bin/ollama

RUN chown -R appuser:appuser $(which ollama) || true

USER appuser

EXPOSE 11434

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
     CMD curl -f http://localhost:11434/ || exit 1
CMD ["/app/start.sh"]