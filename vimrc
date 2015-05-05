" general settings {{{
set nocp                    " forget about compatibility with old version of vi
set termencoding=utf-8
set encoding=utf-8
set fileencodings=
set statusline=%F%m%r%h%w\ %=\ [F=%{&ff}]\ [T=%Y]\ [C=\%05.5b,\%05.5B]\ [P=%04l,%04v][%p%%=%L]
set laststatus=2
set t_Co=256
set t_ut=
colorscheme basic
set guifont=Bitstream\ Vera\ Sans\ Mono\ 10
set ttyfast                 " Smoother changes
set mouse=a
filetype plugin on
set hidden                  " don't kill 'undo' in other buffers
set lazyredraw
set path=.,,**
" }}}

" indenting {{{
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab
set autoindent
set smartindent
set fo+=r                   " Stop the annoying behavior of leaving comments on far left
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%101v', 100)

"make tab in v mode indent code
vmap <tab> >gv
vmap <s-tab> <gv
"make tab in normal mode indent code
nmap <tab> I<tab><esc>
nmap <s-tab> ^i<bs><esc>
" }}}

" Use sane regexes.{{{
nnoremap / /\v
vnoremap / /\v
" }}}

" Highlight Whitespace. Remember 'diw' to kill the tyranny of whitespace! {{{
"====[ Toggle visibility of naughty characters ]============

" Make naughty characters visible...
" (uBB is right double angle, uB7 is middle dot)
exec "set lcs=tab:\uBB\uBB,trail:\uB7,nbsp:~"

augroup VisibleNaughtiness
    autocmd!
    autocmd BufEnter  *       set list
    autocmd BufEnter  *.txt   set nolist
    autocmd BufEnter  *.vp*   set nolist
    autocmd BufEnter  *       if !&modifiable
    autocmd BufEnter  *           set nolist
    autocmd BufEnter  *       endif
augroup END

highlight WhitespaceEOL ctermbg=red guibg=red
autocmd Syntax * syn match WhitespaceEOL /\s\+$\| \+\ze\t/
set wildmode=longest,list:longest,full
"From http://vimcasts.org/episodes/tidying-whitespace/
"Preserves/Saves the state, executes a command, and returns to the saved state
function! Preserve(command)
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
"strip all trailing white space
nnoremap <silent> <leader>dws  :call Preserve("%s/\\s\\+$//e")<CR>:call Preserve("retab")<CR>
" }}}

" keep visual selection on in/out-dent {{{
vnoremap < <gv
vnoremap > >gv
vnoremap = =gv

"=====[ Make arrow keys move visual blocks around ]======================

runtime plugin/dragvisuals.vim

vmap  <expr>  <S-LEFT>   DVB_Drag('left')
vmap  <expr>  <S-RIGHT>  DVB_Drag('right')
vmap  <expr>  <S-DOWN>   DVB_Drag('down')
vmap  <expr>  <S-UP>     DVB_Drag('up')
vmap  <expr>  D          DVB_Duplicate()

" Remove any introduced trailing whitespace after moving...
let g:DVB_TrimWS = 1


" }}}

" searching and line numbers {{{
set ignorecase
set smartcase
set showmatch
set number
set incsearch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <leader>uv :<C-u>Unite -start-insert -no-split -buffer-name=file_vcs file/vcs<CR>
nnoremap <leader>ug :<C-u>Unite -start-insert -no-split vcs_grep/git<CR>
nnoremap <leader>u/ :<C-u>Unite -start-insert -no-split grep:.<CR>
nnoremap <leader>ub :<C-u>Unite -start-insert -no-split buffer<CR>
" }}}

" now search commands will re-center the screen {{{
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz
" }}}

" tab navigation {{{

nnoremap th     :tabfirst<CR>
nnoremap tj     :tabnext<CR>
nnoremap tk     :tabprev<CR>
nnoremap tl     :tablast<CR>
nnoremap tf     :tabfind<Space>
nnoremap tt     :tabedit<Space>
nnoremap tn     :tabnext<Space>
nnoremap tm     :tabm<Space>
nnoremap td     :tabclose<CR>
" }}}

" You don't know what you're missing if you don't use this. {{{
nmap <C-e> :e#<CR>

nmap \0 :buffers<CR>
nmap \1 :e #1<CR>
nmap \2 :e #2<CR>
nmap \3 :e #3<CR>
nmap \4 :e #4<CR>
nmap \5 :e #5<CR>
nmap \6 :e #6<CR>
nmap \7 :e #7<CR>
nmap \8 :e #8<CR>
nmap \9 :e #9<CR>

" move by screen-line, not file-line
noremap j gj
noremap k gk
noremap <Up> gk
noremap <Down> gj

" Swap implementations of ` and ' jump to markers
" By default, ' jumps to the marked line, ` jumps to the marked line and
" column, so swap them
nnoremap ' `
nnoremap ` '

" save file with C-s
nmap <C-s> :w<CR>
:command! Q q

" }}}

" gw will swap this word and the next, even if there weird characters between
nmap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<cr>:nohl<CR>

" Pull word under cursor into LHS of a substitute (for quick search and
" replace)
nmap <leader>z :%s#\<<C-r>=expand("<cword>")<CR>\>#

" emacs follow mode: scroll bind two windows one screenful apart
nmap <silent> <Leader>ef :vsplit<bar>wincmd l<bar>exe "norm! Ljz<c-v><cr>"<cr>:set scb<cr>:wincmd h<cr>:set scb<cr>

" relative number toggle
function! g:ToggleRelativeNumber()
    if &relativenumber
    setlocal number
    else
    setlocal relativenumber
    endif
endfunction

nnoremap <silent> <leader>n :call g:ToggleRelativeNumber()<CR>

" chef syntax
autocmd FileType ruby,eruby set filetype=ruby.eruby.chef

" Conflict markers {{{
" highlight conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" shortcut to jump to next conflict marker
nmap <silent> <C-c> <ESC>/\v^[<=>]{7}( .*\|$)<CR>

" grep/error navigation shortcuts
nmap <C-v><C-n> :cnext<CR>
imap <C-v><C-n> <Esc><C-v><C-n>
nmap <C-v><C-p> :cprev<CR>
imap <C-v><C-p> <Esc><C-v><C-p>
" }}}

" Folding {{{
nnoremap <Space> za
vnoremap <Space> za

" fold code blocks
let perl_fold_pod               = 1
let perl_include_pod     = 1
let perl_fold                   = 1
let perl_extended_vars = 1

" let javaScript_fold=1         " JavaScript

" fold html tags
nnoremap <leader>ft Vatzf
" }}}

" easier pasting
set pastetoggle=<F8>

" make it easy to update/reload vimrc
nmap <Leader>s :source ~/.vimrc<CR>
nmap <Leader>v :e ~/.vimrc<CR>

" use syntax highlighting
syntax enable

" plugin management
execute pathogen#infect()

" Perl specific {{{
" use taglist
let tlist_perl_settings = 'perl;c:constants;l:labels;C:classes;R:roles;r:applied roles;e:superclasses;u:used modules;a:attributes;m:methods;A:runmodes;s:subroutines'
nnoremap <silent> <Leader>tlt :TlistToggle<CR>
let g:Perl_PerlTags = 'disabled'
:set tags=./tags;
source $HOME/.vim/autoload/autotag.vim
let g:SuperTabMappingForward = '<c-space>'
let g:SuperTabMappingBackward = '<s-c-space>'

" perl-support templates
let g:Perl_Template_Module      = "$HOME/.vim/my/perl/templates/module.pm"
let g:Perl_Template_Test        = "$HOME/.vim/my/perl/templates/blank"
let g:Perl_Template_Function    = "$HOME/.vim/my/perl/templates/blank"
let g:Perl_Template_File        = "$HOME/.vim/my/perl/templates/blank"
let g:Perl_Template_Frame       = "$HOME/.vim/my/perl/templates/blank"

" allow use of perltidy profiles
let g:Perl_perltidy_profile = '-moose'

"load html indent if filetype is html
autocmd Filetype html call LoadHTMLIndent()
function! LoadHTMLIndent(...)
    source $VIMRUNTIME/indent/html.vim
endfunction

au BufRead,BufNewFile *.t set filetype=perl | compiler perlprove
au Filetype otl setlocal noexpandtab
autocmd BufWritePost * if &filetype=='perl' | call Perl_SyntaxCheck() | endif
autocmd BufWritePre * :s/\s\+$//e | :retab

" perl tools
let g:ackprg="ack-grep -H --nocolor --nogroup --column"

" cpan changes shortcuts
iab ydate <C-R>=strftime('%F')<CR>
iab yname Rhesa Rozendaal<CR>
iab yemail <rhesa@cpan.org><CR>
iab ychg <C-R>=strftime('%F')<CR>  Rhesa Rozendaal <rhesa@cpan.org><CR>

" refactoring tools
map <Leader>mm <Esc> :call ExtractMethod('method')<CR>
map <Leader>ms <Esc> :call ExtractMethod('sub')<CR>
map <Leader>mr <Esc> :call ExtractMethod('runmode')<CR>

" useful abbreviations
autocmd FileType perl iab ,, =>
autocmd FileType perl iab ppf <C-R>=substitute(substitute(expand("%:p:r"), '/', '::', 'g'), '^.*lib::', '', '')<CR>


" abbreviations for dbic candy
autocmd FileType perl inoreab dcpk   <CR>data_type           => 'int',<CR>is_nullable         => 0,<CR>is_auto_increment   => 1,<CR>extra => { unsigned => 1 },<CR>
autocmd FileType perl inoreab dcuint <CR>data_type   => 'int',<CR>is_nullable => 0,<CR>extra       => { unsigned => 1 },<CR>
autocmd FileType perl inoreab dcvarc <CR>data_type     => 'varchar',<CR>size          => 255,<CR>is_nullable   => 0,<CR>default_value => '',<CR>
autocmd FileType perl inoreab dcdate <CR>data_type       => 'datetime',<CR>is_nullable     => 0,<CR>is_serializable => 1,<CR>
autocmd FileType perl inoreab dcbool <CR>data_type       => 'tinyint',<CR>is_boolean      => 1,<CR>is_nullable     => 0,<CR>default_value   => 0,<CR>extra           => { unsigned => 1 },<CR>
autocmd FileType perl inoreab dccurr <CR>data_type       => 'decimal',<CR>size            => [ 9, 2 ],<CR>is_currency     => 1,<CR>is_nullable     => 0,<CR>default_value   => 0,<CR>is_serializable => 1,<CR>
autocmd FileType perl inoreab dctext <CR>data_type       => 'text',<CR>is_serializable => 1,<CR>default_value   => '',<CR>
autocmd FileType perl inoreab dcenum <CR>data_type   => 'enum',<CR>is_nullable => 0,<CR>values      => [qw( active deleted )],<CR>extra       => { list => [qw( active deleted )] },<CR>


function! ExtractMethod(KeywordName)
    call inputsave()
    let MethodName = input("Method name? ")
    call inputrestore()
    exe "normal zogv"
    execute "'<,'>!extract_method -keyword=" . a:KeywordName . " -name=" . MethodName
endfunction

noremap <Leader>gs  :call GotoSub(expand('<cword>'))<cr>
" only works for Perl
noremap <Leader>gm  :call GotoModule(expand('<cword>'))<cr>
" make sure we pick up the colon as part of our keyword
autocmd FileType perl setlocal iskeyword+=: | setlocal iskeyword-=-

function! GotoSub(subname)
    let files  = []

    " find paths to modules with that sub
    let paths = split(system("ack-grep --perl -l '\(?:sub\|method\|runmode\|has\|func\)\\s+".a:subname."\\b' . lib t/lib"), "\n")

    if empty(paths)
        echomsg("Subroutine '".a:subname."' not found")
    else
        let file = PickFromList('file', paths)
        execute "edit +1 " . file

        " jump to where that sub is defined
        execute "/\\(sub\\|method\\|runmode\\|has\\|func\\)\\s\\+"  . a:subname . "\\>"
    endif
endfunction

let g:perl_path_to = {}
function! GotoModule(module)
    let files  = []

    if !has_key(g:perl_path_to, a:module)
        let g:perl_path_to[a:module] = []
        let lib      = split(system("perl -le 'print join $/ => @INC'"), "\n")
        let module = substitute(a:module, '::', '/', 'g') . '.pm'

        for path in lib
            let path = path . '/' . module
            if filereadable(path)
                let g:perl_path_to[a:module] = g:perl_path_to[a:module] + [ path ]
            endif
        endfor
    endif

    let paths = g:perl_path_to[a:module]
    if empty(paths)
        echomsg("Module '".a:module."' not found")
    else
        let file = PickFromList('file', paths)
    execute "edit +1 " . file
    endif
endfunction

function! PickFromList( name, list, ... )
    let forcelist = a:0 && a:1 ? 1 : 0

    if 1 == len(a:list) && !forcelist
        let choice = 0
    else
        let lines = [ 'Choose a '. a:name . ':' ]
            \ + map(range(1, len(a:list)), 'v:val .": ". a:list[v:val - 1]')
        let choice  = inputlist(lines)
        if choice > 0 && choice <= len(a:list)
            let choice = choice - 1
        else
            let choice = choice - 1
        endif
    end

    return a:list[choice]
endfunction

function! UsePackage()
    let default = expand("<cword>")
    call inputsave()
    let module = input("Module (default " . default . "): ")
    call inputrestore()
    if module == ""
        let module = default
    endif
    normal mz
    normal G$
    call search("^use ", "b")
    call append(line("."), "use " . module . ";")
    normal `z
endfunction

nmap <C-k><C-u> :call UsePackage()<CR>
imap <C-k><C-u> <Esc><C-k><C-u>a

" Copied from plugin/perl-support.vim
"  run : perltidy
"  Also called in the filetype plugin perl.vim
"------------------------------------------------------------------------------
"
let s:Perl_perltidy_startscript_executable = 'no'
let s:Perl_perltidy_module_executable               = 'no'

function! Perl_Perltidy (mode)

    let Sou = expand("%")               " name of the file in the current buffer
    if      (&filetype != 'perl') &&
                \ ( a:mode != 'v' || input( "'".Sou."' seems not to be a Perl file. Continue (y/n) : " ) != 'y' )
        echomsg "'".Sou."' seems not to be a Perl file."
        return
    endif
    "
    " check if perltidy start script is executable
    "
    if s:Perl_perltidy_startscript_executable == 'no'
    if !executable("perltidy")
            echohl WarningMsg
            echo 'perltidy does not exist or is not executable!'
            echohl None
            return
    else
            let s:Perl_perltidy_startscript_executable  = 'yes'
    endif
    endif
    "
    " check if perltidy module is executable
    " WORKAROUND: after upgrading Perl the module will no longer be found
    "
    if s:Perl_perltidy_module_executable == 'no'
    let perltidy_version = system("perltidy -v")
    if match( perltidy_version, 'copyright\c' )         >= 0 &&
    \  match( perltidy_version, 'Steve\s\+Hancock' ) >= 0
            let s:Perl_perltidy_module_executable = 'yes'
    else
            echohl WarningMsg
            echo 'The module Perl::Tidy can not be found! Please reinstall perltidy.'
            echohl None
            return
    endif
    endif
    " ----- normal mode ----------------
    if a:mode=="n"
    if Perl_Input("reformat whole file [y/n/Esc] : ", "y", '' ) != "y"
            return
    endif
    silent exe  ":update"
    let pos1    = line(".")
    silent exe  "%!perltidy -moose 2>/dev/null"
    exe ':'.pos1
    echo 'File "'.Sou.'" reformatted.'
    endif
    " ----- visual mode ----------------
    if a:mode=="v"

    let pos1    = line("'<")
    let pos2    = line("'>")
    silent exe  pos1.",".pos2."!perltidy 2>/dev/null"
    " echo 'File "'.Sou.'" (lines '.pos1.'-'.pos2.') reformatted.'
    endif
    "
    if filereadable("perltidy.ERR")
    echohl WarningMsg
    echo 'Perltidy detected an error when processing file "'.Sou.'". Please see file perltidy.ERR'
    echohl None
    endif
    "
endfunction     " ---------- end of function    Perl_Perltidy  ----------

nmap <Leader>ry :call Perl_Perltidy("n")<CR>
vmap <Leader>ry :call Perl_Perltidy("v")<CR>

" Get the commit responsible for the current line
nmap <Leader>gb :call BlameCurrentLine()<cr>
" Get the current line number & file name, view the git commit that inserted it
fun! BlameCurrentLine()
    let lnum = line(".") . ",". line(".")
    let file = @%
    echon system( "git blame -L " . lnum . " ". file )
endfun

" Vim plugin to highlight variables in Perl.

function! s:hlvar()
    if ( exists( "w:current_match" ) )
        call matchdelete( w:current_match )
        unlet w:current_match
    endif

    let l:old_iskeyword = &iskeyword
    set iskeyword=@,$,%,_,48-57,192-255,@-@
    let l:word = expand( '<cword>' )
    let &iskeyword = l:old_iskeyword

    " we only care about words starting with a sigil
    if ( -1 == match( l:word, '^[%$@]' ) ) 
        return
    endif

    " build up the match by replacing the sigil with the character class [$%@]
    " and appending a word-boundary:
    let l:match = substitute( l:word, '^[$@%]', '[$@%]', '' ) . '\>'

    " do the highlighting
    let w:current_match = matchadd( 'PerlVarHiLight', l:match )
endfunction


if ( ! exists( "g:hlvarnoauto" ) || g:hlvarnoauto == 1 )
    augroup HighlightVar
        autocmd!
        au FileType perl :au CursorMoved * call <SID>hlvar()
        au FileType perl :au CursorMovedI * call <SID>hlvar()
    augroup END

    " only add the highlight group if it doesn't already exist.
    " this way, users can define their own highlighting with their
    " favorite colors by having a "highlight PerlVarHiLight ..." statement
    " in their .vimrc
    if ( ! hlexists( 'PerlVarHiLight' ) )
        highlight PerlVarHiLight ctermbg=black guifg=#ff0000 guibg=#000000 ctermfg=LightGreen gui=bold
    endif

    command! HlVar :call <SID>hlvar()
endif

" }}}

" {{{ Stuff from Damian Conway
"======[ Magically build interim directories if necessary ]===================

function! AskQuit (msg, options, quit_option)
    if confirm(a:msg, a:options) == a:quit_option
        exit
    endif
endfunction

function! EnsureDirExists ()
    let required_dir = expand("%:h")
    if !isdirectory(required_dir)
        call AskQuit("Parent directory '" . required_dir . "' doesn't exist.",
                \           "&Create it\nor &Quit?", 2)

        try
            call mkdir( required_dir, 'p' )
        catch
            call AskQuit("Can't create '" . required_dir . "'",
            \               "&Quit\nor &Continue anyway?", 1)
        endtry
    endif
endfunction

augroup AutoMkdir
    autocmd!
    autocmd  BufNewFile  *  :call EnsureDirExists()
augroup END

"=====[ Configure % key (via matchit plugin) ]==============================

" Match angle brackets...
set matchpairs+=<:>

" Match double-angles, XML tags and Perl keywords...
let TO = ':'
let OR = ','
let b:match_words =
\
\                                   '<<' .TO. '>>'
\
\.OR.           '<\@<=\(\w\+\)[^>]*>' .TO. '<\@<=/\1>'
\
\.OR. '\<if\>' .TO. '\<elsif\>' .TO. '\<else\>'

" Engage debugging mode to overcome bug in matchpairs matching...
let b:match_debug = 1

"=====[ Convert file to different tabspacings ]=====================

function! InferTabspacing ()
    return min(filter(map(getline(1,'$'),'strlen(matchstr(v:val, ''^\s\+''))'),'v:val != 0'))
endfunction

function! NewTabSpacing (newtabsize)
    " Determine apparent tabspacing, if necessary...
    if &tabstop == 4
        let &tabstop = InferTabspacing()
    endif

    " Preserve expansion, if expanding...
    let was_expanded = &expandtab

    " But convert to tabs initially...
    normal TT

    " Change the tabsizing...
    execute "set ts="  . a:newtabsize
    execute "set sw="  . a:newtabsize

    " Update the formatting commands to mirror than new tabspacing...
    execute "map                F !Gformat -T" . a:newtabsize . " -"
    execute "map <silent> f !Gformat -T" . a:newtabsize . "<CR>"

    " Re-expand, if appropriate...
    if was_expanded
        normal TS
    endif
endfunction

" Note, these are all T-<SHIFTED-DIGIT>, which is easier to type...
nmap <silent> T@ :call NewTabSpacing(2)<CR>
nmap <silent> T# :call NewTabSpacing(3)<CR>
nmap <silent> T$ :call NewTabSpacing(4)<CR>
nmap <silent> T% :call NewTabSpacing(5)<CR>
nmap <silent> T^ :call NewTabSpacing(6)<CR>
nmap <silent> T& :call NewTabSpacing(7)<CR>
nmap <silent> T* :call NewTabSpacing(8)<CR>
nmap <silent> T( :call NewTabSpacing(9)<CR>

" Convert to/from spaces/tabs...
nmap <silent> TS :set expandtab<CR>:%retab!<CR>
nmap <silent> TT :set noexpandtab<CR>:%retab!<CR>
nmap <silent> TF TST$

"=====[ Highlight cursor ]===================

" Inverse highlighting for cursor...
highlight CursorInverse   term=inverse ctermfg=black ctermbg=white

" Set up highlighter at high priority (i.e. 100)
call matchadd('CursorInverse', '\%#', 100)

" Need an invisible cursor column to make it update on every cursor move...
" (via the visualguide.vim plugin, so as to play nice)
runtime plugin/visualguide.vim
call VG_Show_CursorColumn('off')


"=====[ Highlight row and column on request ]===================

" Toggle cursor row highlighting on request...
" highlight CursorLine   term=bold ctermfg=black ctermbg=cyan  cterm=bold
highlight CursorLine   term=bold cterm=inverse
nmap <silent> <leader>R :set cursorline!<CR>

" Toggle cursor column highlighting on request...
" (via visualguide.vim plugin, so as to play nice)
nmap <silent> <leader>c :silent call VG_Show_CursorColumn('flip')<CR>

" }}}
" vi: foldmethod=marker
