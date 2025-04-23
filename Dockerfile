FROM python:3.9-slim@sha256:980b778550c0d938574f1b556362b27601ea5c620130a572feb63ac1df03eda5

ENV PYTHONUNBUFFERED True

ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

# Listen on 8080 for Cloud Run
ENV PORT 8080

RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt \
 && pip install psycopg2-binary

# If you need OpenCV dependencies
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
 && rm -rf /var/lib/apt/lists/*

# Switch to source directory
ENV APP_SOURCE /app/src
WORKDIR $APP_SOURCE

# Explicitly declare port
EXPOSE 8080

# Bind to 0.0.0.0:8080 so Cloud Run health checks succeed
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080", "--workers", "1"]
