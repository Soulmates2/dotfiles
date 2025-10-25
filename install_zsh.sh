#!/bin/bash
# oh-my-zsh

function echo_fail {
  # echo first argument in red
  printf "\e[31m✘ ${1}"
  # reset colours back to normal
  printf "\033\e[0m"
  echo ""
}

# display a message in green with a tick by it
# example
# echo echo_fail "Yes"
function echo_pass {
  # echo first argument in green
  printf "\e[32m✔ ${1}"
  # reset colours back to normal
  printf "\033\e[0m"
  echo ""
}

function program_is_installed {
    # set to 1 initially
    local return_=1
    # set to 0 if not found
    type $1 >/dev/null 2>&1 || { local return_=0; }
    # return value
    echo "$return_"
}

if [ $(program_is_installed zsh) == 1 ]; then
    echo_pass zsh
else
    echo_fail zsh
    sudo apt-get install -y zsh
fi

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTON:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${HOME}/.zshrc
echo "source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${HOME}/.zshrc
sed -i 's/robbyrussell/agnoster/' ~/.zshrc

echo 'prompt_context() {
	if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
		prompt_segment black default "%(!.%{%F{yellow}%}.) kunho"
	fi
}' >> ${HOME}/.zshrc

if [ $(program_is_installed nvim) == 1 ]; then
	
	echo 'alias vi="nvim"' >> ~/.zshrc
	echo 'alias vim="nvim"' >> ~/.zshrc
fi

echo '# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/kunho/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/kunho/miniconda3/etc/profile.d/conda.sh" ]; then
         . "/home/kunho/miniconda3/etc/profile.d/conda.sh"
    else
         export PATH="/home/kunho/miniconda3/bin:$PATH"  
    fi
fi
unset __conda_setup
' >> ${HOME}/.zshrc


echo '# CUDA PATH
export PATH=/usr/local/cuda-11.8/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH
' >> ${HOME}/.zshrc


echo '# Hugging Face cache directory
export HF_DATASETS_CACHE=/home/kunho/.cache
export HF_HUB_CACHE=/home/kunho/.cache
export HUGGINGFACE_HUB_CACHE=/home/kunho/.cache
export HF_HOME=/home/kunho/.cache
' >> ${HOME}/.zshrc


source ${HOME}/.zshrc
