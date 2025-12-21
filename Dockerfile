FROM python:3.12-slim


WORKDIR /app
COPY start.sh /start.sh
RUN chmod +x /start.sh
COPY . .
RUN apt-get update && apt-get install -y curl && apt-get install -y build-essential
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install aiohttp
RUN curl -fsSL https://ollama.ai/install.sh |  sh


EXPOSE 11434

CMD ["/start.sh"]