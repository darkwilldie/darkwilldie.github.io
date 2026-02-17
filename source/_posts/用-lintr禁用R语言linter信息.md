---
title: 用.lintr禁用R语言linter信息
date: 2024-10-04 18:32:27
tags:
  - r
  - lintr
  - vscode
categories: environment
---
<meta name="referrer" content="no-referrer" />

R语言linter会在vscode显示几十上百条info，挡住有用信息，而且满屏蓝色波浪线也很难看。没找到能够按要求格式化R脚本的插件，只能用`.lintr`文件来禁用了。

> 注意`.lintr`的语法很坑，空格和逗号稍微变一点都可能非法。尤其注意最后需要是一个换行符！！！

```.lintr
linters: linters_with_defaults(
    line_length_linter = NULL,
    commented_code_linter = NULL,
    T_and_F_symbol_linter = NULL,
    indentation_linter = NULL,
    object_usage_linter = NULL,
    seq_linter = NULL,
    vector_logic_linter = NULL,
    brace_linter = NULL,
    commas_linter = NULL,
    equals_na_linter = NULL,
    function_left_parentheses_linter = NULL,
    object_name_linter = NULL,
    assignment_linter = NULL,
    infix_spaces_linter = NULL,
    spaces_inside_linter = NULL,
    spaces_left_parentheses_linter = NULL,
    trailing_blank_lines_linter = NULL,
    trailing_whitespace_linter = NULL
    )

```

