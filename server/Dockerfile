FROM python:3.8
ADD . /server
WORKDIR /server
RUN pip install pipenv
RUN pipenv install --system --deploy --ignore-pipfile
CMD flask run --host 0.0.0.0