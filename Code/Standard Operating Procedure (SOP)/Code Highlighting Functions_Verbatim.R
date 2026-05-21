#########################################################################
# Syntax Highlighter for PDF Handouts
#
# This R script provides functions to syntax-highlight Bash, R, and Python 
# code for inclusion in PDF handouts generated via Quarto for the DSDE 
# Workshop. It applies the idle-fingers light color theme across all
# languages for consistent, professional formatting.
#
# MAIN FUNCTIONS:
# - format_bash(bash_code)     : Highlight and format bash/shell code
# - format_r(r_code)           : Highlight and format R code
# - format_python(python_code) : Highlight and format Python code
#
# Each language also has component functions (color_* and wrap_verbatim_*)
# for advanced usage.
#
# COLOR SCHEME (idle-fingers light theme):
# - Keywords (if, for, def, git, etc.)  → Purple (#6c71c4) + bold
# - Functions (print, mean, grep, etc.) → Blue (#268bd2)
# - Strings/Files (paths, quoted text)  → Teal (#2aa198)
# - Comments (# text)                   → Gray (#586e75) + italic
# - Operators (|, &&, +, -, etc.)       → Yellow-brown (#b58900)
#
# USAGE:
# ```{r}
# source("syntax_highlighter.R")
# cat(format_bash("git status"))
# cat(format_r("mean(x)"))
# cat(format_python("print('hello')"))
# ```
#
# REQUIREMENTS:
# - R package: stringr
# - LaTeX packages: fancyvrb, xcolor
# - LaTeX commands: \kw, \str, \func, \com, \op (defined in preamble)
#
# LATEX INTEGRATION:
# Define these commands in your PDF formatting preamble:
#
# \newcommand{\kw}[1]{\textcolor{keywordcolor}{\textbf{#1}}}
# \newcommand{\str}[1]{\textcolor{stringcolor}{#1}}
# \newcommand{\com}[1]{\textcolor{commentcolor}{\textit{#1}}}
# \newcommand{\func}[1]{\textcolor{functioncolor}{#1}}
# \newcommand{\op}[1]{\textcolor{operatorcolor}{\textbf{#1}}}
# \newcommand{\atr}[1]{\textcolor{attributecolor}{#1}}
#
# \definecolor{keywordcolor}{HTML}{6c71c4}
# \definecolor{stringcolor}{HTML}{2aa198}
# \definecolor{functioncolor}{HTML}{268bd2}
# \definecolor{commentcolor}{HTML}{586e75}
# \definecolor{operatorcolor}{HTML}{b58900}
# \definecolor{attributecolor}{HTML}{d33682}
# \definecolor{breakarrowcolor}{HTML}{999999}
#
# Author: Shelby Golden, M.S. (with assistance from Yale's AI Clarity)
# Date: February 9th, 2026
#########################################################################


## ----------------------------------------------------------------------------
## SET UP THE ENVIRONMENT
## renv() will install all of the packages and their correct version used here
#renv::init()          # Initialize the project
#renv::restore()       # Download packages and their version saved in the lockfile.

suppressPackageStartupMessages({
  library("stringr")       # For string manipulation
})

# Function to select "Not In"
'%!in%' <- function(x,y)!('%in%'(x,y))




## ----------------------------------------------------------------------------
## BASH

color_bash <- function(bash_code) {
  library(stringr)
  
  # Comprehensive bash keywords (purple)
  keywords <- c(
    # Control flow
    "if", "then", "else", "elif", "fi", "case", "esac", "for", "while", 
    "until", "do", "done", "break", "continue", "return", "function",
    
    # Special keywords
    "in", "select", "time", "declare", "local", "readonly", "export",
    "unset", "shift", "source", "exec", "eval", "test",
    
    # Git/Output keywords
    "Auto-merging", "Automatic", "modified", "deleted", "Version", "left", 
    "tree", "failed", "fix", "conflicts", "result", "upstream", "Merge", 
    "Fast-forward", "up-to-date", "ahead", "behind", "diverged", "nothing", 
    "Changes", "Untracked", "staged", "unstaged"
  )
  
  # Comprehensive bash functions/commands (blue)
  functions <- c(
    # File operations
    "ls", "cd", "pwd", "mkdir", "rmdir", "rm", "cp", "mv", "touch", 
    "ln", "file", "stat", "basename", "dirname",
    
    # Text processing
    "cat", "echo", "printf", "read", "grep", "egrep", "fgrep", "sed", 
    "awk", "cut", "paste", "sort", "uniq", "wc", "tr", "expand", "unexpand",
    "head", "tail", "less", "more", "diff", "cmp", "comm", "join",
    
    # File searching
    "find", "locate", "which", "whereis", "type",
    
    # Permissions
    "chmod", "chown", "chgrp", "umask",
    
    # Process management
    "ps", "top", "htop", "kill", "killall", "pkill", "pgrep", "jobs",
    "bg", "fg", "nohup", "nice", "renice",
    
    # System info
    "uname", "hostname", "uptime", "who", "whoami", "id", "groups",
    "date", "cal", "df", "du", "free", "lsblk", "mount", "umount",
    
    # Networking
    "ping", "curl", "wget", "ssh", "scp", "rsync", "ftp", "sftp",
    "netstat", "ifconfig", "ip", "route", "traceroute", "dig", "nslookup",
    "nc", "telnet",
    
    # Archive/Compression
    "tar", "gzip", "gunzip", "bzip2", "bunzip2", "zip", "unzip",
    "compress", "uncompress", "xz",
    
    # Package managers
    "apt", "apt-get", "yum", "dnf", "brew", "pip", "npm", "gem", "git",
    
    # Other common utilities
    "sudo", "su", "clear", "history", "alias", "unalias", "make",
    "gcc", "g++", "python", "python3", "perl", "ruby", "node",
    "vim", "nano", "emacs", "man", "info", "help", "xargs", "tee",
    "watch", "sleep", "wait", "exit", "logout", "open"
  )
  
  code <- bash_code
  
  # STEP 1: Extract and protect comments FIRST
  comment_placeholders <- list()
  comment_counter <- 0
  code <- str_replace_all(code, regex("#(.+)$", multiline = TRUE), function(matches) {
    sapply(matches, function(match) {
      comment_counter <<- comment_counter + 1
      placeholder <- paste0("@@@COMMENT@", comment_counter, "@@@")
      comment_placeholders[[placeholder]] <<- match
      return(placeholder)
    })
  })
  
  # STEP 2: Protect strings BEFORE file paths
  string_placeholders <- list()
  string_counter <- 0
  
  # Color strings in single quotes
  code <- str_replace_all(code, regex("'([^']*)'"), function(matches) {
    sapply(matches, function(match) {
      string_counter <<- string_counter + 1
      placeholder <- paste0("###STRING###", string_counter, "###")
      string_placeholders[[placeholder]] <<- match
      return(placeholder)
    })
  })
  
  # Color strings in double quotes
  code <- str_replace_all(code, regex('"([^"]*)\"'), function(matches) {
    sapply(matches, function(match) {
      string_counter <<- string_counter + 1
      placeholder <- paste0("###STRING###", string_counter, "###")
      string_placeholders[[placeholder]] <<- match
      return(placeholder)
    })
  })
  
  # Escape special LaTeX characters
  code <- str_replace_all(code, fixed("\\"), "\\\\textbackslash{}")
  code <- str_replace_all(code, fixed("{"), "\\\\{")
  code <- str_replace_all(code, fixed("}"), "\\\\}")
  code <- str_replace_all(code, "&", "\\\\&")
  code <- str_replace_all(code, "%", "\\\\%")
  code <- str_replace_all(code, fixed("$"), "\\\\$")
  
  # STEP 3: Protect file paths AFTER strings are protected
  filepath_placeholders <- list()
  filepath_counter <- 0
  code <- str_replace_all(code, regex("([a-zA-Z0-9_\\-/]+\\.(jpeg|jpg|png|txt|pdf|csv|json|html|xml|yml|yaml|md|sh|py|r|R|c|cpp|h|java|js|ts|sql|log|conf|cfg))"), function(matches) {
    sapply(matches, function(match) {
      filepath_counter <<- filepath_counter + 1
      placeholder <- paste0("###FILEPATH###", filepath_counter, "###")
      filepath_placeholders[[placeholder]] <<- match
      return(placeholder)
    })
  })
  
  # NOW escape remaining underscores (won't affect placeholders)
  code <- str_replace_all(code, "_", "\\\\_")
  
  # Color command-line options/flags (e.g., -m, -f, --force, etc.)
  code <- str_replace_all(code, regex("--[a-zA-Z][a-zA-Z0-9-]*"), function(matches) {
    sapply(matches, function(match) {
      paste0("\\op{", match, "}")
    })
  })
  
  code <- str_replace_all(code, regex("-[a-zA-Z]\\b"), function(matches) {
    sapply(matches, function(match) {
      paste0("\\op{", match, "}")
    })
  })
  
  # Color functions (whole word matching)
  for (func in functions) {
    pattern <- paste0("\\b", func, "\\b")
    replacement <- paste0("\\\\func{", func, "}")
    code <- str_replace_all(code, regex(pattern), replacement)
  }
  
  # Color keywords (whole word matching)
  for (kw in keywords) {
    pattern <- paste0("\\b", kw, "\\b")
    replacement <- paste0("\\\\kw{", kw, "}")
    code <- str_replace_all(code, regex(pattern), replacement)
  }
  
  # Restore file paths (with escaped underscores)
  for (placeholder in names(filepath_placeholders)) {
    fp_content <- filepath_placeholders[[placeholder]]
    fp_escaped <- str_replace_all(fp_content, "_", "\\\\_")
    code <- gsub(placeholder, paste0("\\str{", fp_escaped, "}"), code, fixed = TRUE)
  }
  
  # Restore strings (with all necessary escaping)
  for (placeholder in names(string_placeholders)) {
    string_content <- string_placeholders[[placeholder]]
    
    # Escape special LaTeX characters in string
    string_content <- str_replace_all(string_content, fixed("\\"), "\\\\textbackslash{}")
    string_content <- str_replace_all(string_content, fixed("{"), "\\\\{")
    string_content <- str_replace_all(string_content, fixed("}"), "\\\\}")
    string_content <- str_replace_all(string_content, "&", "\\\\&")
    string_content <- str_replace_all(string_content, "%", "\\\\%")
    string_content <- str_replace_all(string_content, fixed("$"), "\\\\$")
    string_content <- str_replace_all(string_content, "_", "\\\\_")
    
    code <- gsub(placeholder, paste0("\\str{", string_content, "}"), code, fixed = TRUE)
  }
  
  # Process and restore comments
  for (placeholder in names(comment_placeholders)) {
    comment_text <- comment_placeholders[[placeholder]]
    
    # Escape special chars in comment
    comment_text <- str_replace_all(comment_text, fixed("\\"), "\\\\textbackslash{}")
    comment_text <- str_replace_all(comment_text, fixed("{"), "\\\\{")
    comment_text <- str_replace_all(comment_text, fixed("}"), "\\\\}")
    comment_text <- str_replace_all(comment_text, "&", "\\\\&")
    comment_text <- str_replace_all(comment_text, "%", "\\\\%")
    comment_text <- str_replace_all(comment_text, fixed("$"), "\\\\$")
    comment_text <- str_replace_all(comment_text, "_", "\\\\_")
    
    code <- gsub(placeholder, paste0("\\com{", comment_text, "}"), code, fixed = TRUE)
  }
  
  return(code)
}

# Function to wrap the colored code in Verbatim environment
wrap_verbatim <- function(colored_code) {
  paste0(
    "\\begin{Verbatim}[breaklines = true, breaksymbol = \\textcolor{idlelinnum}{\\scriptsize$\\hookrightarrow$}, commandchars = \\\\\\{\\}]\n",
    colored_code,
    "\n\\end{Verbatim}"
  )
}

# Convenience function to do both
format_bash <- function(bash_code) {
  colored <- color_bash(bash_code)
  wrap_verbatim(colored)
}




## ----------------------------------------------------------------------------
## R

color_r <- function(r_code) {
  library(stringr)
  
  # R keywords (purple)
  keywords <- c(
    # Control flow
    "if", "else", "repeat", "while", "for", "break", "next", "return",
    
    # Function definition
    "function",
    
    # Logical operators and constants
    "TRUE", "FALSE", "NULL", "NA", "NaN", "Inf",
    
    # Other keywords
    "library", "require", "source", "attach", "detach"
  )
  
  # R functions (blue)
  functions <- c(
    # Base functions
    "c", "list", "matrix", "array", "data.frame", "factor",
    "print", "cat", "paste", "paste0", "sprintf",
    "length", "dim", "nrow", "ncol", "names", "colnames", "rownames",
    "head", "tail", "str", "summary", "class", "typeof", "mode",
    "mean", "median", "sd", "var", "sum", "min", "max", "range",
    "sort", "order", "rank", "unique", "duplicated", "table",
    "subset", "merge", "rbind", "cbind", "apply", "lapply", "sapply", "tapply",
    "read.csv", "read.table", "write.csv", "write.table",
    "plot", "hist", "boxplot", "barplot", "lines", "points", "abline",
    "par", "legend", "title", "axis", "grid",
    "lm", "glm", "predict", "residuals", "fitted", "coef",
    "t.test", "chisq.test", "cor", "cov",
    "seq", "rep", "rnorm", "runif", "sample",
    "is.na", "is.null", "is.numeric", "is.character", "is.factor",
    "as.numeric", "as.character", "as.factor", "as.data.frame",
    "ifelse", "switch", "tryCatch", "stop", "warning", "message",
    "init", "restore", "as.Date",
    
    # Tidyverse functions
    "ggplot", "aes", "geom_point", "geom_line", "geom_bar", "geom_histogram",
    "mutate", "select", "filter", "arrange", "group_by", "summarize", "summarise",
    "left_join", "right_join", "inner_join", "full_join",
    "pivot_longer", "pivot_wider", "separate", "unite",
    "read_csv", "write_csv", "glimpse",
    "labs", "ggsave", "scale_y_continuous", "scale_x_date",
    "scale_color_manual", "scale_fill_manual",
    "unit_format", "theme_minimal", "label_comma"
  )
  
  code <- r_code
  
  # STEP 1: Protect strings FIRST (before comments, since strings can contain #)
  string_placeholders <- list()
  string_counter <- 0
  code <- str_replace_all(code, regex("'([^']*)'"), function(matches) {
    sapply(matches, function(match) {
      string_counter <<- string_counter + 1
      placeholder <- paste0("XSTRINGX", string_counter, "XSTRINGX")
      string_placeholders[[placeholder]] <<- match
      return(placeholder)
    })
  })
  
  # Color strings in double quotes
  code <- str_replace_all(code, regex('"([^"]*)\"'), function(matches) {
    sapply(matches, function(match) {
      string_counter <<- string_counter + 1
      placeholder <- paste0("XSTRINGX", string_counter, "XSTRINGX")
      string_placeholders[[placeholder]] <<- match
      return(placeholder)
    })
  })
  
  # STEP 2: Extract and protect comments AFTER strings are protected
  comment_placeholders <- list()
  comment_counter <- 0
  code <- str_replace_all(code, regex("#(.*)$", multiline = TRUE), function(matches) {
    sapply(matches, function(match) {
      comment_counter <<- comment_counter + 1
      placeholder <- paste0("XCOMMENTX", comment_counter, "XCOMMENTX")
      comment_placeholders[[placeholder]] <<- match
      return(placeholder)
    })
  })
  
  # STEP 2.5: Protect %in% and %>% operators BEFORE escaping % characters
  operator_placeholders <- list()
  operator_counter <- 0
  
  # Protect %in%
  code <- str_replace_all(code, fixed("%in%"), function(matches) {
    sapply(matches, function(match) {
      operator_counter <<- operator_counter + 1
      placeholder <- paste0("XOPERATORX", operator_counter, "XOPERATORX")
      operator_placeholders[[placeholder]] <<- "in"
      return(placeholder)
    })
  })
  
  # Protect %>%
  code <- str_replace_all(code, fixed("%>%"), function(matches) {
    sapply(matches, function(match) {
      operator_counter <<- operator_counter + 1
      placeholder <- paste0("XOPERATORX", operator_counter, "XOPERATORX")
      operator_placeholders[[placeholder]] <<- ">"
      return(placeholder)
    })
  })
  
  # Escape special LaTeX characters
  code <- str_replace_all(code, fixed("\\"), "\\\\textbackslash{}")
  code <- str_replace_all(code, fixed("{"), "\\\\{")
  code <- str_replace_all(code, fixed("}"), "\\\\}")
  code <- str_replace_all(code, "&", "\\\\&")
  code <- str_replace_all(code, "%", "\\\\%")
  code <- str_replace_all(code, fixed("$"), "\\\\$")
  
  # STEP 3: Protect file paths with placeholders
  filepath_placeholders <- list()
  filepath_counter <- 0
  code <- str_replace_all(code, regex("([a-zA-Z0-9_\\-/]+\\.(csv|txt|rds|rda|RData|xlsx|json|xml|html|jpeg|jpg|png))"), function(matches) {
    sapply(matches, function(match) {
      filepath_counter <<- filepath_counter + 1
      placeholder <- paste0("XFILEPATHX", filepath_counter, "XFILEPATHX")
      filepath_placeholders[[placeholder]] <<- match
      return(placeholder)
    })
  })
  
  # Color named arguments (parameter = value pattern) - BEFORE escaping underscores
  argument_placeholders <- list()
  argument_counter <- 0
  code <- str_replace_all(code, regex("([a-zA-Z][a-zA-Z0-9_]*)(\\s*=)(?!=)"), function(matches) {
    sapply(matches, function(match) {
      argument_counter <<- argument_counter + 1
      placeholder <- paste0("XARGUMENTX", argument_counter, "XARGUMENTX")
      parts <- str_match(match, "([a-zA-Z][a-zA-Z0-9_]*)(\\s*=)")
      param_name <- parts[,2]
      spaces_and_equals <- parts[,3]
      argument_placeholders[[placeholder]] <<- paste0(param_name, spaces_and_equals)
      return(placeholder)
    })
  })
  
  # Color functions BEFORE escaping underscores - use a unique marker
  function_placeholders <- list()
  function_counter <- 0
  for (func in functions) {
    pattern <- paste0("\\b", func, "\\s*\\(")
    code <- str_replace_all(code, regex(pattern), function(matches) {
      sapply(matches, function(match) {
        function_counter <<- function_counter + 1
        placeholder <- paste0("XFUNCTIONX", function_counter, "XFUNCTIONX")
        function_placeholders[[placeholder]] <<- func
        # Keep the opening parenthesis and any whitespace
        gsub(paste0("\\b", func), placeholder, match)
      })
    })
  }
  
  # Escape remaining underscores
  code <- str_replace_all(code, "_", "\\\\_")
  
  # Replace function placeholders with colored versions (after underscores are escaped)
  for (placeholder in names(function_placeholders)) {
    func <- function_placeholders[[placeholder]]
    func_escaped <- str_replace_all(func, "_", "\\\\_")
    code <- gsub(placeholder, paste0("\\func{", func_escaped, "}"), code, fixed = TRUE)
  }
  
  # Color numbers FIRST (including scientific notation)
  code <- str_replace_all(code, regex("(?<!X)\\b([0-9]+\\.?[0-9]*([eE][+-]?[0-9]+)?)\\b(?!X)"), function(matches) {
    sapply(matches, function(match) {
      paste0("\\op{", match, "}")
    })
  })
  
  # Color operators using gsub
  code <- gsub("<-", "\\op{<-}", code, fixed = TRUE)
  code <- gsub("->", "\\op{->}", code, fixed = TRUE)
  code <- gsub("|>", "\\op{|>}", code, fixed = TRUE)
  code <- gsub("==", "\\op{==}", code, fixed = TRUE)
  code <- gsub("+", "\\op{+}", code, fixed = TRUE)
  code <- gsub("*", "\\op{*}", code, fixed = TRUE)
  code <- gsub("/", "\\op{/}", code, fixed = TRUE)
  code <- gsub("::", "\\op{::}", code, fixed = TRUE)
  
  # Color keywords
  for (kw in keywords) {
    pattern <- paste0("\\b", kw, "\\b")
    code <- str_replace_all(code, regex(pattern), function(matches) {
      sapply(matches, function(match) {
        paste0("\\kw{", match, "}")
      })
    })
  }
  
  # Restore operator placeholders (after keywords are colored)
  # The % is already escaped to \%, so we build the final string with \%
  for (placeholder in names(operator_placeholders)) {
    op_middle <- operator_placeholders[[placeholder]]
    # Build \op{\%in\%} or \op{\%>\%}
    code <- gsub(placeholder, paste0("\\op{\\%", op_middle, "\\%}"), code, fixed = TRUE)
  }
  
  # Restore arguments
  for (placeholder in names(argument_placeholders)) {
    arg_content <- argument_placeholders[[placeholder]]
    arg_content_escaped <- str_replace_all(arg_content, "_", "\\\\_")
    code <- gsub(placeholder, paste0("\\atr{", arg_content_escaped, "}"), code, fixed = TRUE)
  }
  
  # Restore file paths
  for (placeholder in names(filepath_placeholders)) {
    fp_content <- filepath_placeholders[[placeholder]]
    fp_escaped <- str_replace_all(fp_content, "_", "\\\\_")
    code <- gsub(placeholder, paste0("\\str{", fp_escaped, "}"), code, fixed = TRUE)
  }
  
  # Restore strings
  for (placeholder in names(string_placeholders)) {
    string_content <- string_placeholders[[placeholder]]
    
    # Escape special LaTeX characters in string
    string_content <- str_replace_all(string_content, fixed("\\"), "\\\\textbackslash{}")
    string_content <- str_replace_all(string_content, fixed("{"), "\\\\{")
    string_content <- str_replace_all(string_content, fixed("}"), "\\\\}")
    string_content <- str_replace_all(string_content, "&", "\\\\&")
    string_content <- str_replace_all(string_content, "%", "\\\\%")
    string_content <- str_replace_all(string_content, fixed("$"), "\\\\$")
    string_content <- str_replace_all(string_content, "_", "\\\\_")
    
    code <- gsub(placeholder, paste0("\\str{", string_content, "}"), code, fixed = TRUE)
  }
  
  # Restore comments
  for (placeholder in names(comment_placeholders)) {
    comment_text <- comment_placeholders[[placeholder]]
    
    # Restore string placeholders within comments
    for (str_placeholder in names(string_placeholders)) {
      if (grepl(str_placeholder, comment_text, fixed = TRUE)) {
        string_content <- string_placeholders[[str_placeholder]]
        comment_text <- gsub(str_placeholder, string_content, comment_text, fixed = TRUE)
      }
    }
    
    # Escape special chars in comment
    comment_text <- str_replace_all(comment_text, fixed("\\"), "\\\\textbackslash{}")
    comment_text <- str_replace_all(comment_text, fixed("{"), "\\\\{")
    comment_text <- str_replace_all(comment_text, fixed("}"), "\\\\}")
    comment_text <- str_replace_all(comment_text, "&", "\\\\&")
    comment_text <- str_replace_all(comment_text, "%", "\\\\%")
    comment_text <- str_replace_all(comment_text, fixed("$"), "\\\\$")
    comment_text <- str_replace_all(comment_text, "_", "\\\\_")
    
    code <- gsub(placeholder, paste0("\\com{", comment_text, "}"), code, fixed = TRUE)
  }
  
  return(code)
}

# Function to wrap the colored R code in Verbatim environment
wrap_verbatim_r <- function(colored_code) {
  paste0(
    "\\begin{Verbatim}[breaklines = true, breaksymbol = \\textcolor{idlelinnum}{\\scriptsize$\\hookrightarrow$}, commandchars = \\\\\\{\\}]\n",
    colored_code,
    "\n\\end{Verbatim}"
  )
}

# Convenience function for R
format_r <- function(r_code) {
  colored <- color_r(r_code)
  wrap_verbatim_r(colored)
}




## ----------------------------------------------------------------------------
## Python

color_python <- function(python_code) {
  library(stringr)
  
  # Python keywords (purple)
  keywords <- c(
    # Control flow
    "if", "elif", "else", "for", "while", "break", "continue", "pass", "return",
    
    # Function/class definition
    "def", "class", "lambda",
    
    # Exception handling
    "try", "except", "finally", "raise", "assert",
    
    # Logical operators and constants
    "True", "False", "None", "and", "or", "not", "is", "in",
    
    # Import statements
    "import", "from", "as",
    
    # Other keywords
    "with", "yield", "global", "nonlocal", "del", "async", "await"
  )
  
  # Python functions (blue)
  functions <- c(
    # Built-in functions
    "print", "input", "len", "range", "type", "isinstance", "str", "int", "float",
    "list", "tuple", "dict", "set", "bool",
    "sum", "min", "max", "abs", "round", "pow",
    "sorted", "reversed", "enumerate", "zip", "map", "filter",
    "open", "read", "write", "close",
    "append", "extend", "insert", "remove", "pop", "index", "count",
    "split", "join", "strip", "replace", "format",
    "keys", "values", "items", "get", "update",
    
    # Common library functions
    "np.array", "np.mean", "np.median", "np.std", "np.sum", "np.arange", "np.linspace",
    "pd.DataFrame", "pd.read_csv", "pd.read_excel", "to_csv", "head", "tail",
    "describe", "groupby", "merge", "concat", "pivot_table",
    "plt.plot", "plt.scatter", "plt.hist", "plt.bar", "plt.xlabel", "plt.ylabel",
    "plt.title", "plt.legend", "plt.show", "plt.savefig"
  )
  
  code <- python_code
  
  # Escape special LaTeX characters
  code <- str_replace_all(code, fixed("\\"), "\\\\textbackslash{}")
  code <- str_replace_all(code, fixed("{"), "\\\\{")
  code <- str_replace_all(code, fixed("}"), "\\\\}")
  code <- str_replace_all(code, "&", "\\\\&")
  code <- str_replace_all(code, "%", "\\\\%")
  code <- str_replace_all(code, fixed("$"), "\\\\$")
  
  # Color file paths with extensions
  code <- str_replace_all(code, regex("([a-zA-Z0-9_\\-/]+\\.(csv|txt|py|json|xml|html|pkl|h5|parquet))"), function(match) {
    escaped_match <- str_replace_all(match, "_", "\\_")
    paste0("\\str{", escaped_match, "}")
  })
  
  # Color strings in single quotes
  code <- str_replace_all(code, regex("'([^']*)'"), function(match) {
    content <- str_match(match, "'([^']*)'")[,2]
    escaped_content <- str_replace_all(content, "_", "\\_")
    paste0("\\str{'", escaped_content, "'}")
  })
  
  # Color strings in double quotes
  code <- str_replace_all(code, regex('"([^"]*)\"'), function(match) {
    content <- str_match(match, '"([^"]*)"')[,2]
    escaped_content <- str_replace_all(content, "_", "\\_")
    paste0('\\str{"', escaped_content, '"}')
  })
  
  # Escape remaining underscores
  code <- str_replace_all(code, "_", "\\\\_")
  
  # Color functions
  for (func in functions) {
    pattern <- paste0("\\b", func, "\\b")
    replacement <- paste0("\\\\func{", func, "}")
    code <- str_replace_all(code, regex(pattern), replacement)
  }
  
  # Color keywords
  for (kw in keywords) {
    pattern <- paste0("\\b", kw, "\\b")
    replacement <- paste0("\\\\kw{", kw, "}")
    code <- str_replace_all(code, regex(pattern), replacement)
  }
  
  # Color comments (everything after #)
  code <- str_replace_all(code, regex("#(.+)$"), "\\\\com{# \\1}")
  
  return(code)
}

# Function to wrap the colored Python code in Verbatim environment
wrap_verbatim_python <- function(colored_code) {
  paste0(
    "\\begin{Verbatim}[breaklines = true, breaksymbol = \\textcolor{idlelinnum}{\\scriptsize$\\hookrightarrow$}, commandchars = \\\\\\{\\}]\n",
    colored_code,
    "\n\\end{Verbatim}"
  )
}

# Convenience function for Python
format_python <- function(python_code) {
  colored <- color_python(python_code)
  wrap_verbatim_python(colored)
}


