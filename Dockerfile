# Qwen2-VL-7B-Instruct RunPod Serverless Docker Image
# For BigTooth brushing session verification
# NOTE: Using eager attention instead of flash-attn for faster builds

FROM runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04

# Set working directory
WORKDIR /app

# Install Python dependencies (skip flash-attn to avoid build issues)
RUN pip install --no-cache-dir \
    runpod \
    transformers>=4.45.0 \
    accelerate>=0.26.0 \
    pillow \
    requests \
    qwen-vl-utils

# Pre-download the model during build (makes cold starts faster)
RUN python -c "from transformers import Qwen2VLForConditionalGeneration, AutoProcessor; \
    print('Downloading Qwen2-VL-7B-Instruct...'); \
    Qwen2VLForConditionalGeneration.from_pretrained('Qwen/Qwen2-VL-7B-Instruct', torch_dtype='auto'); \
    AutoProcessor.from_pretrained('Qwen/Qwen2-VL-7B-Instruct'); \
    print('Model downloaded successfully!')"

# Copy handler
COPY handler.py /app/handler.py

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV TRANSFORMERS_CACHE=/runpod-volume/huggingface
ENV HF_HOME=/runpod-volume/huggingface

# Start handler
CMD ["python", "-u", "/app/handler.py"]
