if exists('g:macnote_note_directory')
  execute 'autocmd BufRead,BufNewFile '.g:macnote_note_directory.'/* setfiletype note'
else
  let root = expand('~').'/Documents/notes'
  execute 'autocmd BufRead,BufNewFile '.root.'/* setfiletype note'
endif
