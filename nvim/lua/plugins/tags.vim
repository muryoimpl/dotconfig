set tags=./.tags,.tags
set tags+=./ruby.tags,ruby.tags
set tags+=./go.tags,go.tags
set tags+=./typescript.tags,typescript.tags
set tags+=./typescriptreact.tags,typescriptreact.tags
set tags+=./javascript.tags,javascript.tags
set tags+=./javascriptreact.tags,javascriptreact.tags

"飛ぶ
nnoremap tt  <C-]>
"「進む」
nnoremap tj  :tag<Return>
"「戻る」
nnoremap tk  :pop<Return>
"履歴一覧
nnoremap tl  :tags<Return>
