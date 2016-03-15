if exists('did_macnote_loaded') || v:version < 704
  finish
endif
let did_macnote_loaded = 1
let s:save_cpo = &cpo
set cpo&vim

let s:sample_file = expand('<sfile>:h:h').'/template/sample'
let s:note_dir = get(g:, 'macnote_note_directory', expand('~').'/Documents/notes')

function! s:EditNote(name)
  let path =  s:note_dir . '/' . a:name
  if isdirectory(path)
    execute 'edit ' . path
  elseif filereadable(path)
    execute 'edit ' . path
  else
    " directory
    if match(a:name, '\v/$') != -1 && exists('*mkdir')
      call mkdir(path, 'p')
    else
      let slash = match(a:name, '/') != -1
      if slash
        let dir = s:note_dir. '/' .fnamemodify(a:name, ':h')
        if !isdirectory(dir)
          call mkdir(dir, 'p')
        endif
      endif
      let newfile = !filereadable(path)
      execute 'edit ' . path
      if newfile && filereadable(s:sample_file)
        let lines = readfile(s:sample_file)
        call setline(1, lines[0])
        call append(1, lines[1:])
      endif
    endif
  endif
endfunction

function! s:DeleteNote(name) abort
  let path = simplify(s:note_dir . '/' . a:name)
  if !filereadable(path) && !isdirectory(path)
    echohl ErrorMsg | echon a:name . ' not find' | echohl None
    return
  endif
  if isdirectory(path)
    if input('Are your sure delete folder ' . a:name . '? [y/n]') =~? 'y'
      let output = system('rm -r '. path)
      if v:shell_error && output !=# ""
        echohl Error | echon output | echohl None
      endif
      return
    endif
  endif
  if input('Are your sure delete ' . a:name . '? [y/n]') =~? 'y'
    let nr = bufnr(path)
    if nr != -1
      if exists(':Bdelete')
        silent execute 'Bdelete ' . nr
      else
        silent execute 'bwipeout ' . nr
      endif
    endif
    let output = system('rm -f ' . path)
    if v:shell_error && output !=# ""
      echohl Error | echon output | echohl None
    endif
  endif
endfunction

function! s:NoteComplete(A, L, P)
  let slash = match(a:A, '/') != -1
  let word = slash ? matchstr(a:A, '\v[^/]*$') : a:A
  let dir =  slash ? s:note_dir . '/' . fnamemodify(a:A, ':h') : s:note_dir
  if !isdirectory(dir) | return | endif
  let output = system('ls -F '. dir.'/ |grep "^' . word . '"')
  if slash
    let list = map(split(output, "\n"), '"'.fnamemodify(a:A, ':h').'/".v:val')
  else
    let list = split(output, "\n")
  endif
  return map(list, 'substitute(fnameescape(v:val), "@", "/", "")')
endfunction

function! s:Preview()
  if get(b:, 'macnote_auto_preview', 0) == 0 | return | endif
  silent call macnote#preview()
endfunction

function! s:AutoPreview()
  if get(b:, 'macnote_auto_preview', 0)
    let b:macnote_auto_preview = 0
    echohl MoreMsg | echon 'auto preview disabled' | echohl None
  else
    let b:macnote_auto_preview = 1
    call s:Preview()
    echohl MoreMsg | echon 'auto preview enabled' | echohl None
  endif
endfunction

function! s:VisualPreview(start, end)
  call macnote#preview(a:start, a:end)
endfunction

function! s:OnVimEnter()
  if isdirectory(s:note_dir) | return | endif
  if !exists('*mkdir')
    echohl Error | echon 'Root directory '.s:note_dir.' for macnote not exists' | echohl None
  endif
  if input('Root directory '.s:note_dir.' for notes not exists, create ?[y/n]', 'y') =~? 'y'
    call mkdir(s:note_dir , 'p')
  endif
endfunction

function! s:OnVimLeave()
  for buf in range(1, bufnr('$'))
    if bufloaded(buf)
      if getbufvar(buf, '&ft') ==# 'note'
        call macnote#closeTab(buf)
      endif
    endif
  endfor
endfunction

function! s:InitNote()
  command! -buffer -range=% -nargs=0 Preview :call s:VisualPreview(<line1>, <line2>)
  command! -buffer -nargs=0 PreviewAuto :call s:AutoPreview()
endfunction

function! s:SearchNote(word, bang)
  let g:grep_command = 'grep'.a:bang.' '.a:word.' '.s:note_dir
  execute 'silent '.g:grep_command
  if get(g:, 'macnote_unite_quickfix', 0) == 1
    execute 'Unite -buffer-name=quickfix  quickfix'
  elseif get(g:, 'macnote_cwindow_open', 1) == 1
    cwindow
  endif
endfunction

augroup macnote
  autocmd!
  autocmd filetype note call s:InitNote()
  autocmd VimEnter * call s:OnVimEnter()
  autocmd VimLeave * call s:OnVimLeave()
  autocmd BufDelete * call macnote#closeTab(+expand('<abuf>'))
  autocmd BufWrite  * call s:Preview()
augroup end

command! -nargs=1 -complete=customlist,s:NoteComplete Note :call s:EditNote(<f-args>)
command! -nargs=1 -complete=customlist,s:NoteComplete NoteDelete :call s:DeleteNote(<f-args>)
command! -nargs=1 -bang NoteSearch :call s:SearchNote(<q-args>, <q-bang>)

let &cpo = s:save_cpo
