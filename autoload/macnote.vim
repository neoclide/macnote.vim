let s:root = expand('<sfile>:p:h:h')
let s:www_root = s:root.'/www'
let s:chrome_load = s:root .'/bin/chrome_load'
let s:chrome_close = s:root.'/bin/chrome_close'
let s:programme = s:root.'/bin/marked'
let s:default_template = s:root.'/template/default.html'
let s:note_dir = get(g:, 'macnote_note_directory', expand('~').'/Documents/notes')

function! macnote#preview(...) abort
  if a:0 == 2
    let list = getline(a:1, a:2)
  else
    let list = getline(1, '$')
  endif
  let tmp = tempname()
  call writefile(list, tmp)
  let dest = s:getDestination()
  let programme = s:programme . ' ' . s:getTemplate()
  let commands = ['cat '.tmp.'|'. programme.' &> '
        \. dest, s:chrome_load . '  file://' . dest]
  let execute_file = tempname()
  call writefile(commands, execute_file)
  let g:exe = execute_file
  if exists('*vimproc#system')
    call vimproc#system('bash ' . execute_file . ' &')
  else
    call s:system('bash ' . execute_file)
  endif
endfunction

function! macnote#closeTab(buf)
  let dest = getbufvar(a:buf, 'macnote_desc')
  let g:dest = dest
  if empty(dest) | return | endif
  call s:system(s:chrome_close . ' file://' . dest)
endfunction

function! s:getDestination()
  if exists('b:macnote_desc') | return b:macnote_desc | endif
  let path = expand('%:p')[len(expand(s:note_dir)) + 1:]
  let b:macnote_desc = s:www_root.'/'.substitute(path, '/', '_', 'g').'.html'
  return b:macnote_desc
endfunction

function! s:getTemplate()
  let tmp = expand('%:h').'/template.html'
  if filereadable(tmp) | return tmp | endif
  return s:default_template
endfunction

function! s:system(cmd)
  let output =  system(a:cmd)
  if v:shell_error && output !=# ""
    echohl Error | echon output | echohl None
    return
  endif
endfunction
