# temp stage
FROM python:3.9-slim as base
# Setup env
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1


FROM base AS python-deps

# Install pipenv and compilation dependencies
RUN pip install pipenv
RUN apt-get update && apt-get install -y --no-install-recommends gcc

# Install python dependencies in /.venv
# COPY Pipfile .
# COPY Pipfile.lock .
COPY requirements.txt .
# RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy
RUN PIPENV_VENV_IN_PROJECT=1 pipenv install -r requirements.txt


FROM base AS runtime

ARG PORT=3000
ARG OTHERS="others"

# Copy virtual env from python-deps stage
COPY --from=python-deps /.venv /.venv
ENV PATH="/.venv/bin:$PATH"
ENV PORT=${PORT}
ENV OTHERS=${OTHERS}



# Create and switch to a new user
RUN useradd --create-home appuser
WORKDIR /home/appuser
USER appuser

# Install application into container
COPY . .



# Run the application
# ENTRYPOINT ["python -m flask run app"]
# RUN pip install -r requirements.txt

# ENTRYPOINT [ "python -m app.py" ]
CMD [ "python" , "./app.py" ]