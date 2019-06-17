# firestore-emulator

## Usage

```bash
docker build -t firestore-emulator:latest .
docker run -i -t -p 8000:8000 -v /path/to/init.d:/init.d firestore-emulator:latest
```
