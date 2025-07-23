sed -n '/call plug#begin()/,/call plug#end()/p' ./vimrc > ./vimrc.0
mv ./vimrc.0 $HOME/.vimrc
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c "PlugInstall | qa!"

cp ./vimrc $HOME/.vimrc

vim -c "CocInstall coc-pyright | CocInstall coc-json | CocInstall coc-pairs | qa!"

mkdir -p $HOME/.vim
cp ./coc-settings.json $HOME/.vim/
