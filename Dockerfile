FROM python:3.9

# 
WORKDIR /app

# 
COPY ./requirements.txt /app/requirements.txt

# 
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt


RUN \
  apt-get update && \
  apt-get install -y sudo curl git && \
  curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
  sudo apt-get install git-lfs


RUN git lfs install


RUN git clone --no-checkout --depth 1 https://github.com/codefactory4791/summarization.git
RUN cd summarization && git lfs pull -I pytorch_model.bin

# 
COPY . /app

# download the model weights in the image
RUN python /app/app/model/model.py

# 
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8888"]S