docker run -it \
    --ipc=host \
    --pid=host \
    --restart unless-stopped \
    --gpus all \
    --privileged \
    -p 4022:22 \
    --name kunho \
    -h geometry1docker \
    -v /home/kaist984/docker:/home/kaist984 \
    -v /scratch:/scratch \
    kaist984 \
    /bin/zsh
