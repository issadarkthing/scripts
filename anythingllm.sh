export STORAGE_LOCATION=$HOME/anythingllm
docker run -d -p 3001:3001 \
    --cap-add SYS_ADMIN \
    -v ${STORAGE_LOCATION}:/app/server/storage \
    -v ${STORAGE_LOCATION}/.env:/app/server/.env \
    -e STORAGE_DIR="/app/server/storage" \
    mintplexlabs/anythingllm
