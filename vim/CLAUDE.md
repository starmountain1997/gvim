这是一个便利地配置vim的项目

用户会运行 @install_gvim.sh 来安装项目

当配置prabirshrestha/vim-lsp的时候永远记得参考文档
prabirshrestha/vim-lsp要与mattn/vim-lsp-settings、asyncomplete.vim一起搭配使用
mattn/vim-lsp-settings会自动配置语言服务器，无需手动配置pylsp

注意，你在修改 @vimrc 的时候一定要加上中文注释，@README.md 也要一并修改

每次修改完运行 @install_gvim.sh 来重新安装，如果有错误就修改
