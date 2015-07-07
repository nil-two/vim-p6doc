" Open perl6 document with p6doc
" Version: 0.1.0
" Author : wara <kusabashira227@gmail.com>
" License: MIT License

if exists('g:loaded_p6doc')
  finish
endif
let g:loaded_p6doc = 1

let s:save_cpo = &cpo
set cpo&vim


command! -nargs=* Perldoc
\ call p6doc#open(<q-args>)

noremap <silent> <Plug>(p6doc) :<C-u>Perldoc<CR>

" Default key mappings.
if !hasmapto('<Plug>(p6doc)')
\  && (!exists('g:p6doc_no_default_key_mappings')
\      || !g:p6doc_no_default_key_mappings)
  silent! nmap <silent> K <Plug>(p6doc)
endif

let &cpo = s:save_cpo
unlet s:save_cpo
