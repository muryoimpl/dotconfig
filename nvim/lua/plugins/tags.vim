set tags=./.tags,.tags
set tags+=.git/tags

"飛ぶ
nnoremap tt  <C-]>
"「進む」
nnoremap tj  :tag<Return>
"「戻る」
nnoremap tk  :pop<Return>
"履歴一覧
nnoremap tl  :tags<Return>

" ==================================
"          vim-auto-ctags
" ==================================
let g:auto_ctags = 1
let g:auto_ctags_set_tags_option = 0
let g:auto_ctags_tags_name = 'tags'
let g:auto_ctags_tags_args = ['--tag-relative', '--recurse', '--sort=yes', '-f .git/tags']
let g:auto_ctags_warn_once = 1
let g:auto_ctags_filetype_mode = 0
" au BufWritePost *.rb,*.js,*.ts silent! !ctags -R -f .tags &
