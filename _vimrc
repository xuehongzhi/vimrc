set nocompatible 
filetype off                  " required

if !exists('g:plugins')
   let g:plugins=[]
endif
let g:plugins+= ['tomasiser/vim-code-dark', 'VundleVim/Vundle.vim', 'lrvick/Conque-Shell', 'taglist.vim', 'winmanager', 'scrooloose/nerdtree',  'tpope/vim-fugitive', 'L9', 'BufExplorer.zip', 'maksimr/vim-jsbeautify', 'kien/ctrlp.vim','rking/ag.vim']
let $path=$path.";d:\\program files (x86)\\nodejs;d:\\program files (x86)\\git\\bin;D:\\cygwin64\\bin"
let $pyver=strpart(&g:pythonthreedll,6,2)
let $path="d:\\python".$pyver.";d:\\python".$pyver."\\Scripts;".$path
" set the runtime path to include Vundle and initialize
set rtp+=$VIM/vimfiles/bundle/Vundle.vim
call vundle#begin('$VIM/vimfiles/bundle/')
" alternatively, pass a path where Vundle should install plugins
:for i in g:plugins
Plugin  i
:endfor
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.Plugin
Bundle 'rstacruz/sparkup', {'rtp': 'vim'} 
" All of your Plugins must be added before the following line
call vundle#end()            " required
 

source $VIMRUNTIME/vimrc_example.vim 
source $VIMRUNTIME/mswin.vim 
"设置鼠标运行模式为WINDOWS模式 
:behave mswin 
" Multi-encoding setting, MUST BE IN THE BEGINNING OF .vimrc! 
" 
if has("multi_byte") 
    " When 'fileencodings' starts with 'ucs-bom', don't do this manually 
    "set bomb 
    set fileencodings=ucs-bom,utf-8,chinese,taiwan,japan,korea,latin1 
    " CJK environment detection and corresponding setting 
    if v:lang =~ "^zh_CN" 
        " Simplified Chinese, on Unix euc-cn, on MS-Windows cp936 
        set encoding=chinese 
        set termencoding=chinese 
        if &fileencoding == '' 
            set fileencoding=chinese 
        endif 
    elseif v:lang =~ "^zh_TW" 
        " Traditional Chinese, on Unix euc-tw, on MS-Windows cp950 
        set encoding=taiwan 
        set termencoding=taiwan 
        if &fileencoding == '' 
            set fileencoding=taiwan 
        endif 
    elseif v:lang =~ "^ja_JP" 
        " Japanese, on Unix euc-jp, on MS-Windows cp932 
        set encoding=japan 
        set termencoding=japan 
        if &fileencoding == '' 
            set fileencoding=japan 
        endif 
    elseif v:lang =~ "^ko" 
        " Korean on Unix euc-kr, on MS-Windows cp949 
        set encoding=korea 
        set termencoding=korea 
        if &fileencoding == '' 
            set fileencoding=korea 
        endif 
    endif 
    " Detect UTF-8 locale, and override CJK setting if needed 
    if v:lang =~ "utf8$" || v:lang =~ "UTF-8$" 
        set encoding=utf-8 
    endif 
else 
    echoerr 'Sorry, this version of (g)Vim was not compiled with "multi_byte"' 
endif 
    
set diffexpr=MyDiff()
function! MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        let cmd = 'diff'
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction 

"解决菜单乱码 
set encoding=utf-8 
"fileencodings需要注意顺序，前面的字符集应该比后面的字符集大 
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1 
set langmenu=zh_CN.utf-8 
set imcmdline 
source $VIMRUNTIME/delmenu.vim 
source $VIMRUNTIME/menu.vim 
 
"解决consle输出乱码 
language messages zh_CN.utf-8 
 
"自动检测文件类型并加载相应的设置，snipMate插件需要打开这个配置选项 
filetype plugin indent on 
autocmd GUIEnter * simalt ~x
if has('gui_running') && has('win32')
    map <F11> :call libcallnr('gvimfullscreen.dll', 'ToggleFullScreen', 0)<CR>
endif

let g:NERDTree_title="NERDTree"
let g:winManagerWindowLayout="NERDTree|TagList,BufExplorer"
let g:NERDTreeChDirMode=2
let g:ConqueTerm_PyVersion = 3
let g:ag_prg="D:\\cygwin64\\bin\\ag.exe --vimgrep"
function! NERDTree_Start()
    let   t:NERDTreeBufName =g:NERDTree_title 	
    if empty(getbufvar(bufnr(t:NERDTreeBufName), 'NERDTree'))
	    let b:NERDTree=t:NERDTreeBufName
    endif
    exec 'NERDTree'
endfunction

function! NERDTree_IsValid()
    return 1
endfunction

function! WinToggle()
  exe 'WMToggle'
  exe '1wincmd w'
  exe 'wincmd H'
endfunction

noremap wm :call WinToggle()<CR>

map <caps_lock> <caps_lock>:redraw<CR> 

autocmd FileType javascript noremap :call JsBeautify()
" for html
autocmd FileType html noremap :call HtmlBeautify()
" for css or scss
autocmd FileType css noremap :call CSSBeautify()
vnoremap  <C-f> :call RangeHtmlBeautify()<cr>

:nn <M-1> 1gt
:nn <M-2> 2gt
:nn <M-3> 3gt
:nn <M-4> 4gt
:nn <M-5> 5gt
:nn <M-6> 6gt
:nn <M-7> 7gt
:nn <M-8> 8gt
:nn <M-9> 9gt
:nn <M-0> :tablast<CR>
set nobackup
set nowritebackup
set noundofile
"set stl=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %{vimcaps#statusline(1)}\ %P
colorscheme codedark
set guioptions-=m
set guioptions-=T
