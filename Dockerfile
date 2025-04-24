FROM python:3.9-slim

ENV PYTHONUNBUFFERED=1 \
    APP_HOME=/app \
    PORT=8080

WORKDIR $APP_HOME
COPY . ./

RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt \
 && pip install psycopg2-binary

# Remove GUI libs—use headless OpenCV only
# (Drop libgl1-mesa-glx and libglib2.0-0 entirely)

WORKDIR $APP_HOME/src

EXPOSE 8080

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080", "--workers", "1"]
