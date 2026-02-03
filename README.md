# Qwen2-VL-7B-Instruct Session Verification

RunPod serverless endpoint for BigTooth brushing session verification using Qwen2-VL-7B-Instruct vision model.

## Build & Deploy

### 1. Build Docker Image

```bash
cd /Users/pietbez/Documents/Apps/Bigtooth-Dev/runpod-endpoints/qwen-vision

# Build for AMD64 (RunPod requires this)
docker buildx build --platform linux/amd64 -t pietbez/bigtooth-qwen-vision:latest --push .
```

### 2. Create RunPod Serverless Endpoint

1. Go to [RunPod Serverless](https://www.runpod.io/console/serverless)
2. Click "New Endpoint"
3. Settings:
   - **Name**: `bigtooth-qwen-vision`
   - **Container Image**: `pietbez/bigtooth-qwen-vision:latest`
   - **GPU Type**: RTX 4090 or A6000 (24GB VRAM)
   - **Min Workers**: 0
   - **Max Workers**: 3
   - **Idle Timeout**: 5 seconds
   - **Execution Timeout**: 180 seconds

### 3. Add Endpoint ID to .env

```env
RUNPOD_VISION_ENDPOINT_ID=your_endpoint_id_here
```

## API Usage

### Request

```json
{
  "input": {
    "photoUrls": [
      "https://example.com/photo1.jpg",
      "https://example.com/photo2.jpg",
      "https://example.com/photo3.jpg",
      "https://example.com/photo4.jpg"
    ],
    "strictMode": false
  }
}
```

Or with base64 images:

```json
{
  "input": {
    "photoBase64": [
      "base64_encoded_image_1...",
      "base64_encoded_image_2...",
      "base64_encoded_image_3...",
      "base64_encoded_image_4..."
    ],
    "strictMode": false
  }
}
```

### Response

```json
{
  "success": true,
  "approved": true,
  "confidence": 0.85,
  "reason": "Genuine brushing session detected",
  "detailedAnalysis": {
    "faceDetected": true,
    "toothbrushVisible": true,
    "toothbrushInMouth": true,
    "toothbrushChangedLocation": true,
    "suspiciousPatterns": []
  }
}
```

## Verification Modes

### Lenient Mode (default)

Requires 3 of 4 criteria:
- Face visible ✓
- Toothbrush visible ✓
- Toothbrush in mouth ✓
- Movement optional

Confidence threshold: 60%

### Strict Mode

Requires ALL 4 criteria:
- Face visible ✓
- Toothbrush visible ✓
- Toothbrush in mouth ✓
- Toothbrush changed location ✓

Confidence threshold: 80%

## Model Details

- **Model**: Qwen2-VL-7B-Instruct
- **License**: Apache 2.0
- **VRAM**: ~14-16GB (BF16)
- **Inference Time**: 3-8 seconds
# Build trigger Tue Feb  3 10:32:11 SAST 2026
# Build trigger Tue Feb  3 12:02:34 SAST 2026
# Force rebuild 2026-02-03-12:55:37
