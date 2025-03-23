mkdir -p ~/.cache
mkdir -p ~/save
mkdir -p /data
mkdir -p /db_dir
docker run \
       --gpus all \
       --runtime=nvidia \
       --shm-size=2g \
       --rm --init \
       --network host \
       -v /etc/passwd:/etc/passwd:ro \
       -v /etc/group:/etc/group:ro \
       -u `id -u`:`id -g` \
       -v "${HOME}"/.cache:/workspace/.cache \
       -v "${HOME}"/save:/workspace/save \
       -v /data:/workspace/user_path \
       -v /db_dir:/workspace/db_dir_UserData \
       ghcr.io/f15hb0wn/h2ogpt:latest /workspace/src/make_db.py --verbose --add_if_exists=True
