let s:save_cpo = &cpo
set cpo&vim

if executable('ag')
  let s:command = 'ag ' . get(g:, 'unite_note_ag_opts', "--nocolor --nogroup -g ''")
endif

let s:note_dir = get(g:, 'macnote_note_directory', expand('~').'/Documents/notes')

let s:source = {
            \ 'name': 'note',
            \ 'description' : 'vim note source',
            \ 'hooks' : {},
            \ 'action_table': {},
            \ }

let s:source.action_table.new = {
            \ 'description' : 'create note',
            \ 'is_quit' : 1
            \ }

let s:source.action_table.delete = {
            \ 'description' : 'remove note',
            \ 'is_quit' : 1
            \ }

function! s:source.action_table.new.func(candidate)
  call feedkeys(':Note ', 'n')
endfunction

function! s:source.action_table.delete.func(candidate)
  let name = fnamemodify(a:candidate.action__path, ':t')
  if input('Remove note '.name.' ? [y/n] ', 'y') =~? 'y'
    if bufnr(a:candidate.action__path) != -1
      if exists(':Bdelete')
        execute 'bwipeout '. a:candidate.action__path
      else
        execute 'bwipeout '. a:candidate.action__path
      endif
    endif
    let output = system('rm -f ' . a:candidate.action__path)
    if v:shell_error && output !=# ""
      echohl Error | echon output | echohl None
      return
    endif
    echo 'done'
  endif
endfunction

function! s:source.hooks.on_init(args, context) abort
endfunction

function! s:source.hooks.on_close(args, context)
endfunction

function! s:source.gather_candidates(args, context)
  if exists('s:command')
    let output = system(s:command. ' ' . s:note_dir)
    if v:shell_error && output !=# ""
      call unite#print_source_error(
            \ output, s:source.name)
      return
    endif
  else
    let output = glob(s:note_dir . '/**/*')
  endif
  let paths = split(output, "\n")
  let l = len(s:note_dir)
  return map(paths, '{
        \ "word": v:val[l + 1 : ],
        \ "kind": "file",
        \ "source": "note",
        \ "action__path": v:val,
        \}')
endfunction

function! unite#sources#note#define()
  return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
