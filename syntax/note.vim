syntax match FrontMatter /\v%^\_.{-}\ze\n---\s*$/

syntax match YamlIdentifier /\v^\w+:/

syntax match YamlDelimeter /:/ contained containedin=YamlIdentifier

syntax match YamlItemStart /^\s*\zs-\%(\s\+-\)*\s/

highlight default link YamlIdentifier Identifier
highlight default link YamlDelimeter Special
highlight default link YamlItemStart Statement

syntax include @MARKDOWN syntax/markdown.vim

syntax region Markdown start=/\v^---\s*$/ end=/\v%$/ contains=@MARKDOWN
