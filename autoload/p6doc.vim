" Open perl6 document with p6doc
" Version: 0.1.0
" Author : wara <kusabashira227@gmail.com>
" License: MIT License

function! s:win_exists(bufnr)
  return bufwinnr(a:bufnr) != -1
endfunction

function! s:exit_with_success(command)
  silent call system(a:command)
  if v:shell_error != 0
    return 0
  else
    return 1
  endif
endfunction

function! s:avariable_class(class)
  return s:exit_with_success('p6doc ' . a:class)
endfunction

function! s:avariable_func(func)
  return s:exit_with_success('p6doc -f ' . a:func)
endfunction

let s:docbuf = {
\   'bufnr': -1,
\   'title': '[p6doc]',
\ }

function! s:docbuf.open_buf() abort
  if bufexists(s:docbuf.bufnr) && s:win_exists(s:docbuf.bufnr)
    execute bufwinnr(s:docbuf.bufnr) . 'wincmd w'
  elseif !bufexists(s:docbuf.bufnr)
    new
    execute 'file ' . s:docbuf.title
    let s:docbuf.bufnr = bufnr('%')
  elseif !s:win_exists(s:docbuf.bufnr)
    split
    execute s:docbuf.bufnr . 'buffer'
  endif
endfunction

function! s:docbuf.read_doc(p6doc_args) abort
  setlocal modifiable
  silent execute '%!p6doc ' . a:p6doc_args
  setfiletype man
  setlocal nomodifiable
endfunction

function! s:docbuf.configure() abort
  setlocal filetype=man
  setlocal bufhidden=delete
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal nobuflisted
  setlocal modifiable
  setlocal iskeyword+=:

  silent! noremap <buffer> <silent> K <Plug>(p6doc)

  autocmd! BufHidden <buffer>
  \ call let <SID>p6doc_buffer_number = -1
endfunction

function! s:docbuf.open_doc(p6doc_args)
  let wd = getcwd()
  call s:docbuf.open_buf()
  call s:docbuf.read_doc(a:p6doc_args)
  call s:docbuf.configure()
  execute ':lcd ' . wd
endfunction

function! p6doc#open(...)
  let keyword = join(a:000, ' ')
  if strlen(keyword) == 0
    let keyword = expand('<cword>')
  endif

  if s:avariable_class(keyword)
    call s:docbuf.open_doc(keyword)
  elseif s:avariable_func(keyword)
    call s:docbuf.open_doc('-f', keyword)
  else
    echo 'No documentation found for "' . keyword . '".'
  end
endfunction
