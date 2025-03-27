## Edit Variables
export HUGGING_FACE_HUB_TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
export SERPAPI_API_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
export MODEL="unsloth/Llama-3.2-3B-Instruct-unsloth-bnb-4bit"
export GRADIO_SERVER_PORT=7860
export OPENAI_SERVER_PORT=5000
# Create directories
mkdir -p ~/.cache/huggingface/hub/
mkdir -p ~/.triton/cache/
mkdir -p ~/.config/vllm/
mkdir -p ~/.cache
mkdir -p ~/save
mkdir -p ~/users
mkdir -p ~/db_nonusers
mkdir -p ~/llamacpp_path
mkdir -p ~/h2ogpt_auth
mkdir -p /data
mkdir -p /db_dir
echo '["key1","key2"]' > ~/h2ogpt_auth/h2ogpt_api_keys.json
# Run Docker
docker run \
       --gpus all \
       --runtime=nvidia \
       --shm-size=2g \
       -p $GRADIO_SERVER_PORT:$GRADIO_SERVER_PORT \
       -p $OPENAI_SERVER_PORT:$OPENAI_SERVER_PORT \
       --rm --init \
       -e USER_AGENT='Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:69.0) Gecko/20100101' \
       -e SERPAPI_API_KEY=$SERPAPI_API_KEY \
       --name h2ogpt \
       --network host \
       -v /etc/passwd:/etc/passwd:ro \
       -v /etc/group:/etc/group:ro \
       -u `id -u`:`id -g` \
       -v "${HOME}"/.cache/huggingface/hub/:/workspace/.cache/huggingface/hub \
       -v "${HOME}"/.config:/workspace/.config/ \
       -v "${HOME}"/.triton:/workspace/.triton/  \
       -v "${HOME}"/save:/workspace/save \
       -v /data:/workspace/user_path \
       -v /db_dir:/workspace/db_dir_UserData \
       -v "${HOME}"/users:/workspace/users \
       -v "${HOME}"/db_nonusers:/workspace/db_nonusers \
       -v "${HOME}"/llamacpp_path:/workspace/llamacpp_path \
       -v "${HOME}"/h2ogpt_auth:/workspace/h2ogpt_auth \
       -e GRADIO_SERVER_PORT=$GRADIO_SERVER_PORT \
       ghcr.io/f15hb0wn/h2ogpt:latest /workspace/generate.py \
          --base_model=$MODEL \
          --use_safetensors=True \
          --save_dir='/workspace/save/' \
          --use_gpu_id=False \
          --user_path=/workspace/user_path \
          --langchain_mode="UserData" \
          --use_auth_token="${HUGGING_FACE_HUB_TOKEN}" \
          --load_4bit=True
