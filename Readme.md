# Macnote.vim

Simplified and friendly note management plugin.

## Basic features

* Write note with markdown and yaml as frontmatter.
* Preview in Chrome with range and auto reload support.
* Create, delete and search note with command.
* Unite source for easier note management.

## Install

Take [vundle](https://github.com/VundleVim/Vundle.vim) as example:

    Plugin 'chemzqm/macnote.vim'

To enable async markdown parse, install
[vimproc.vim](https://github.com/Shougo/vimproc.vim)

    Plugin 'Shougo/vimproc.vim'

## Usage

* Create or edit note:

        :Note {path}

  _{path} could include folder, use `<tab>` for auto complete_

* Delete note;

        :NoteDelete {path}

* Search note:

        :[bang]NoteSearch {path}

* Preview current note:

        :Preview

* Auto reload preview on file save and cursor hold:

        :PreviewAuto

  _Chrome tab would be close on buffer delete_

* Open unite source for note:

        :Unite note

  _There is `open` `delete` `add` action for unite note source_

## Configurations

All configurations are optional.

* `g:macnote_note_directory` could be used to set root directory of notes,
  defaults: `~/Documents/notes`
* `g:note_cwindow_open` could be set to `1` if you want open quickfix list after
  search.
* `g:note_unite_quickfix` if you have unite quickfix source, set it to `1` to
  open unite quickfix source after search.
* `g:unite_note_ag_opts` is used for set options for ag, which is ued for file
  search in unite note, default value is `--nocolor --nogroup -g ''`

## License

MIT
