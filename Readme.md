# Macnote.vim

[![](http://img.shields.io/github/issues/neoclide/macnote.vim.svg)](https://github.com/neoclide/macnote.vim/issues)
[![](http://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![](https://img.shields.io/badge/doc-%3Ah%20macnote.txt-red.svg)](doc/macnote.txt)

Simplified and friendly note management plugin.

## Basic features

* Write note with markdown and yaml as frontmatter.
* All extended markdown syntax included, visit [sample page](https://chemzqm.me/sample).
* Preview in Chrome with range and auto reload support.
* Create, delete and search note with command.
* Denite source for easier note management.
* Support both neovim/vim job-control for async parsing.

## Install

Take [vundle](https://github.com/VundleVim/Vundle.vim) as example:

    Plugin 'chemzqm/macnote.vim'

`misaka` and `pygments` is used for high preformance markdown parse and syntax
highlight, you can install them via:

    pip install pygments misaka

If your vim doesn't support, you can install
[vimproc.vim](https://github.com/Shougo/vimproc.vim)

    Plugin 'Shougo/vimproc.vim'

to do async job.

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

* Open Denite source for note:

      Denite note

  _There are `open` `delete` `add` actions for denite note source_

## Configurations

All configurations are optional.

* `g:macnote_note_directory` could be used to set root directory of notes,
  defaults: `~/Documents/notes`
* `g:note_cwindow_open` could be set to `1` if you want open quickfix list after
  search.
* `g:note_denite_quickfix` if you have [denite quickfix source](https://github.com/neoclide/denite-extra/blob/master/rplugin/python3/denite/source/quickfix.py),
  set it to `1` to open denite quickfix source after search.

Use `:h macnote` inside vim to get more info.

## LICENSE

MIT
