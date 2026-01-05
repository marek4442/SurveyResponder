FROM python:3.12-slim


WORKDIR /app
RUN apt-get update && apt-get install -y curl && apt-get install -y build-essential
RUN curl -O https://raw.githubusercontent.com/adamrossnelson/SurveyResponder/main/SurveyResponder.py
RUN curl -O https://raw.githubusercontent.com/adamrossnelson/SurveyResponder/main/requirements.txt
RUN curl -O https://raw.githubusercontent.com/adamrossnelson/SurveyResponder/main/persona.json
RUN curl -O https://raw.githubusercontent.com/adamrossnelson/SurveyResponder/main/questions.txt
RUN curl -O https://raw.githubusercontent.com/marek4442/SurveyResponder/batching/start.sh
RUN curl -o https://raw.githubusercontent.com/adamrossnelson/SurveyResponder/main/cli.py
COPY SurveyResponder.py /SurveyResponder.py
COPY requirements.txt /requirements.txt
COPY persona.json /persona.json
COPY questions.txt /questions.txt
COPY start.sh /start.sh
RUN chmod +x /start.sh
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install aiohttp
RUN curl -fsSL https://ollama.ai/install.sh |  sh


EXPOSE 11434

CMD ["/start.sh"]