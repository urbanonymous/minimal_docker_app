 # Use a Python runtime as a parent image
FROM frolvlad/alpine-python3

# Set metadata about the maintainer of the image
LABEL maintainer="Urbano Gutierrez <@urbiGT>"

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Install any needed packages specified in requirements.txt
#RUN pip install --upgrade pip
RUN pip install -r requirements.txt


# Run main.py when the container is ready
CMD ["python", "-u", "main.py"]