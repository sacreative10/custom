
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local get_visual = function(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

-- Math context detection 
local tex = {}
tex.in_mathzone = function() return vim.fn['vimtex#syntax#in_mathzone']() == 1 end
tex.in_text = function() return not tex.in_mathzone() end
local line_begin = function(line_to_cursor, matched_trigger)
  -- +1 because `string.sub("abcd", 1, -2)` -> abc
  return line_to_cursor:sub(1, -(#matched_trigger + 1)):match("^%s*$")
end
-- A logical OR of `line_begin` and the regTrig '[^%a]trig'
function line_begin_or_non_letter(line_to_cursor, matched_trigger)
  local line_begin = line_to_cursor:sub(1, -(#matched_trigger + 1)):match("^%s*$")
  local non_letter = line_to_cursor:sub(-(#matched_trigger + 1), -(#matched_trigger + 1)):match("[^%a]")
  return line_begin or non_letter
end
-- Return snippet tables
return
{
  -- LEFT/RIGHT PARENTHESES
  s({trig = "([^%a])l%(", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\left(<>\\right)",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- LEFT/RIGHT SQUARE BRACES
  s({trig = "([^%a])l%[", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\left[<>\\right]",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- LEFT/RIGHT CURLY BRACES
  s({trig = "([^%a])l%{", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\left\\{<>\\right\\}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- BIG PARENTHESES
  s({trig = "([^%a])b%(", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\big(<>\\big)",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- BIG SQUARE BRACES
  s({trig = "([^%a])b%[", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\big[<>\\big]",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- BIG CURLY BRACES
  s({trig = "([^%a])b%{", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\big\\{<>\\big\\}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- ESCAPED CURLY BRACES
  s({trig = "([^%a])\\%{", regTrig = true, wordTrig = false, snippetType="autosnippet", priority=2000},
    fmta(
      "<>\\{<>\\}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- LATEX QUOTATION MARK
  s({trig = "``", snippetType="autosnippet"},
    fmta(
      "``<>''",
      {
        d(1, get_visual),
      }
    )
  ),
    -- environments
    -- GENERIC ENVIRONMENT
    s({trig="new", snippetType="autosnippet"},
      fmta(
        [[
        \begin{<>}
            <>
        \end{<>}
      ]],
        {
          i(1),
          d(2, get_visual),
          rep(1),
        }
      ),
      {condition = line_begin}
    ),
    -- ENVIRONMENT WITH ONE EXTRA ARGUMENT
    s({trig="n2", snippetType="autosnippet"},
      fmta(
        [[
        \begin{<>}{<>}
            <>
        \end{<>}
      ]],
        {
          i(1),
          i(2),
          d(3, get_visual),
          rep(1),
        }
      ),
      { condition = line_begin }
    ),
    -- ENVIRONMENT WITH TWO EXTRA ARGUMENTS
    s({trig="n3", snippetType="autosnippet"},
      fmta(
        [[
        \begin{<>}{<>}{<>}
            <>
        \end{<>}
      ]],
        {
          i(1),
          i(2),
          i(3),
          d(4, get_visual),
          rep(1),
        }
      ),
      { condition = line_begin }
    ),
    -- TOPIC ENVIRONMENT (my custom tcbtheorem environment)
    s({trig="nt", snippetType="autosnippet"},
      fmta(
        [[
        \begin{topic}{<>}{<>}
            <>
        \end{topic}
      ]],
        {
          i(1),
          i(2),
          d(3, get_visual),
        }
      ),
      { condition = line_begin }
    ),
    -- EQUATION
    s({trig="nn", snippetType="autosnippet"},
      fmta(
        [[
        \begin{equation*}
            <>
        \end{equation*}
      ]],
        {
          i(1),
        }
      ),
      { condition = line_begin }
    ),
    -- SPLIT EQUATION
    s({trig="ss", snippetType="autosnippet"},
      fmta(
        [[
        \begin{equation*}
            \begin{split}
                <>
            \end{split}
        \end{equation*}
      ]],
        {
          d(1, get_visual),
        }
      ),
      { condition = line_begin }
    ),
    -- ALIGN
    s({trig="all", snippetType="autosnippet"},
      fmta(
        [[
        \begin{align*}
            <>
        \end{align*}
      ]],
        {
          i(1),
        }
      ),
      {condition = line_begin}
    ),
    -- ITEMIZE
    s({trig="itt", snippetType="autosnippet"},
      fmta(
        [[
        \begin{itemize}

            \item <>

        \end{itemize}
      ]],
        {
          i(0),
        }
      ),
      {condition = line_begin}
    ),
    -- ENUMERATE
    s({trig="enn", snippetType="autosnippet"},
      fmta(
        [[
        \begin{enumerate}

            \item <>

        \end{enumerate}
      ]],
        {
          i(0),
        }
      )
    ),
    s({trig = "([^%l])mm", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>$<>$",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      )
    ),
    -- INLINE MATH ON NEW LINE
    s({trig = "^mm", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "$<>$",
{
          i(1),
        })),
    -- FIGURE
    s({trig = "fig"},
      fmta(
        [[
        \begin{figure}[htb!]
          \centering
          \includegraphics[width=<>\linewidth]{<>}
          \caption{<>}
          \label{fig:<>}
        \end{figure}
        ]],
        {
          i(1),
          i(2),
          i(3),
          i(4),
        }
      ),
      { condition = line_begin }
    ),
    -- SUPERSCRIPT
  s({trig = "([%w%)%]%}])'", wordTrig=false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- SUBSCRIPT
  s({trig = "([%w%)%]%}]);", wordTrig=false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- SUBSCRIPT AND SUPERSCRIPT
  s({trig = "([%w%)%]%}])__", wordTrig=false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>^{<>}_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- TEXT SUBSCRIPT
  s({trig = 'sd', snippetType="autosnippet", wordTrig=false},
    fmta("_{\\mathrm{<>}}",
      { d(1, get_visual) }
    ),
    {condition = tex.in_mathzone}
  ),
  -- SUPERSCRIPT SHORTCUT
  -- Places the first alphanumeric character after the trigger into a superscript.
  s({trig = '([%w%)%]%}])"([%w])', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        f( function(_, snip) return snip.captures[2] end ),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- SUBSCRIPT SHORTCUT
  -- Places the first alphanumeric character after the trigger into a subscript.
  s({trig = '([%w%)%]%}]):([%w])', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        f( function(_, snip) return snip.captures[2] end ),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- EULER'S NUMBER SUPERSCRIPT SHORTCUT
  s({trig = '([^%a])ee', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>e^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual)
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- ZERO SUBSCRIPT SHORTCUT
  s({trig = '([%a%)%]%}])00', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        t("0")
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- MINUS ONE SUPERSCRIPT SHORTCUT
  s({trig = '([%a%)%]%}])11', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        t("-1")
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- J SUBSCRIPT SHORTCUT (since jk triggers snippet jump forward)
  s({trig = '([%a%)%]%}])JJ', wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        t("j")
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- PLUS SUPERSCRIPT SHORTCUT
  s({trig = '([%a%)%]%}])%+%+', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        t("+")
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- COMPLEMENT SUPERSCRIPT
  s({trig = '([%a%)%]%}])CC', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        t("\\complement")
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- CONJUGATE (STAR) SUPERSCRIPT SHORTCUT
  s({trig = '([%a%)%]%}])%*%*', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        t("*")
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- VECTOR, i.e. \vec
  s({trig = "([^%a])vv", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\vec{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- DEFAULT UNIT VECTOR WITH SUBSCRIPT, i.e. \unitvector_{}
  s({trig = "([^%a])ue", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\unitvector_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- UNIT VECTOR WITH HAT, i.e. \uvec{}
  s({trig = "([^%a])uv", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\uvec{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- MATRIX, i.e. \vec
  s({trig = "([^%a])mt", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\mat{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- FRACTION
  s({trig = "([^%a])ff", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\frac{<>}{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
        i(2),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- ANGLE
  s({trig = "([^%a])gg", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\ang{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- ABSOLUTE VALUE
  s({trig = "([^%a])aa", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\abs{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- SQUARE ROOT
  s({trig = "([^%\\])sq", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\sqrt{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- BINOMIAL SYMBOL
  s({trig = "([^%\\])bnn", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\binom{<>}{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- LOGARITHM WITH BASE SUBSCRIPT
  s({trig = "([^%a%\\])ll", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\log_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- DERIVATIVE with denominator only
  s({trig = "([^%a])dV", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\dvOne{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- DERIVATIVE with numerator and denominator
  s({trig = "([^%a])dvv", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\dv{<>}{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2)
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- DERIVATIVE with numerator, denominator, and higher-order argument
  s({trig = "([^%a])ddv", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\dvN{<>}{<>}{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2),
        i(3),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- PARTIAL DERIVATIVE with denominator only
  s({trig = "([^%a])pV", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\pdvOne{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- PARTIAL DERIVATIVE with numerator and denominator
  s({trig = "([^%a])pvv", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\pdv{<>}{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2)
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- PARTIAL DERIVATIVE with numerator, denominator, and higher-order argument
  s({trig = "([^%a])ppv", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\pdvN{<>}{<>}{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2),
        i(3),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- SUM with lower limit
  s({trig = "([^%a])sM", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\sum_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- SUM with upper and lower limit
  s({trig = "([^%a])smm", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\sum_{<>}^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- INTEGRAL with upper and lower limit
  s({trig = "([^%a])intt", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\int_{<>}^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- INTEGRAL from positive to negative infinity
  s({trig = "([^%a])intf", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\int_{\\infty}^{\\infty}",
      {
        f( function(_, snip) return snip.captures[1] end ),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- BOXED command
  s({trig = "([^%a])bb", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\boxed{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual)
      }
    ),
    {condition = tex.in_mathzone}
  ),
  --
  -- BEGIN STATIC SNIPPETS
  --

  -- DIFFERENTIAL, i.e. \diff
  s({trig = "df", snippetType="autosnippet", priority=2000, snippetType="autosnippet"},
    {
      t("\\diff"),
    },
    {condition = tex.in_mathzone}
  ),
  -- BASIC INTEGRAL SYMBOL, i.e. \int
  s({trig = "in1", snippetType="autosnippet"},
    {
      t("\\int"),
    },
    {condition = tex.in_mathzone}
  ),
  -- DOUBLE INTEGRAL, i.e. \iint
  s({trig = "in2", snippetType="autosnippet"},
    {
      t("\\iint"),
    },
    {condition = tex.in_mathzone}
  ),
  -- TRIPLE INTEGRAL, i.e. \iiint
  s({trig = "in3", snippetType="autosnippet"},
    {
      t("\\iiint"),
    },
    {condition = tex.in_mathzone}
  ),
  -- CLOSED SINGLE INTEGRAL, i.e. \oint
  s({trig = "oi1", snippetType="autosnippet"},
    {
      t("\\oint"),
    },
    {condition = tex.in_mathzone}
  ),
  -- CLOSED DOUBLE INTEGRAL, i.e. \oiint
  s({trig = "oi2", snippetType="autosnippet"},
    {
      t("\\oiint"),
    },
    {condition = tex.in_mathzone}
  ),
  -- GRADIENT OPERATOR, i.e. \grad
  s({trig = "gdd", snippetType="autosnippet"},
    {
      t("\\grad "),
    },
    {condition = tex.in_mathzone}
  ),
  -- CURL OPERATOR, i.e. \curl
  s({trig = "cll", snippetType="autosnippet"},
    {
      t("\\curl "),
    },
    {condition = tex.in_mathzone}
  ),
  -- DIVERGENCE OPERATOR, i.e. \divergence
  s({trig = "DI", snippetType="autosnippet"},
    {
      t("\\div "),
    },
    {condition = tex.in_mathzone}
  ),
  -- LAPLACIAN OPERATOR, i.e. \laplacian
  s({trig = "laa", snippetType="autosnippet"},
    {
      t("\\laplacian "),
    },
    {condition = tex.in_mathzone}
  ),
  -- PARALLEL SYMBOL, i.e. \parallel
  s({trig = "||", snippetType="autosnippet"},
    {
      t("\\parallel"),
    }
  ),
  -- CDOTS, i.e. \cdots
  s({trig = "cdd", snippetType="autosnippet"},
    {
      t("\\cdots"),
    }
  ),
  -- LDOTS, i.e. \ldots
  s({trig = "ldd", snippetType="autosnippet"},
    {
      t("\\ldots"),
    }
  ),
  -- EQUIV, i.e. \equiv
  s({trig = "eqq", snippetType="autosnippet"},
    {
      t("\\equiv "),
    }
  ),
  -- SETMINUS, i.e. \setminus
  s({trig = "stm", snippetType="autosnippet"},
    {
      t("\\setminus "),
    }
  ),
  -- SUBSET, i.e. \subset
  s({trig = "sbb", snippetType="autosnippet"},
    {
      t("\\subset "),
    }
  ),
  -- APPROX, i.e. \approx
  s({trig = "px", snippetType="autosnippet"},
    {
      t("\\approx "),
    },
    {condition = tex.in_mathzone}
  ),
  -- PROPTO, i.e. \propto
  s({trig = "pt", snippetType="autosnippet"},
    {
      t("\\propto "),
    },
    {condition = tex.in_mathzone}
  ),
  -- COLON, i.e. \colon
  s({trig = "::", snippetType="autosnippet"},
    {
      t("\\colon "),
    }
  ),
  -- IMPLIES, i.e. \implies
  s({trig = ">>", snippetType="autosnippet"},
    {
      t("\\implies "),
    }
  ),
  -- DOT PRODUCT, i.e. \cdot
  s({trig = ",.", snippetType="autosnippet"},
    {
      t("\\cdot "),
    }
  ),
  -- CROSS PRODUCT, i.e. \times
  s({trig = "xx", snippetType="autosnippet"},
    {
      t("\\times "),
    }
  ),
    -- ANNOTATE (custom command for annotating equation derivations)
    s({trig = "ann", snippetType="autosnippet"},
      fmta(
        [[
      \annotate{<>}{<>}
      ]],
        {
          i(1),
          d(2, get_visual),
        }
      )
    ),
    -- REFERENCE
    s({trig = " RR", snippetType="autosnippet", wordTrig=false},
      fmta(
        [[
      ~\ref{<>}
      ]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- DOCUMENTCLASS
    s({trig = "dcc", snippetType="autosnippet"},
      fmta(
        [=[
        \documentclass[<>]{<>}
        ]=],
        {
          i(1, "a4paper"),
          i(2, "article"),
        }
      ),
      { condition = line_begin }
    ),
    -- USE A LATEX PACKAGE
    s({trig = "pack", snippetType="autosnippet"},
      fmta(
        [[
        \usepackage{<>}
        ]],
        {
          d(1, get_visual),
        }
      ),
      { condition = line_begin }
    ),
    -- INPUT a LaTeX file
    s({trig = "inn", snippetType="autosnippet"},
      fmta(
        [[
      \input{<><>}
      ]],
        {
          i(1, "~/dotfiles/config/latex/templates/"),
          i(2)
        }
      ),
      { condition = line_begin }
    ),
    -- LABEL
    s({trig = "lbl", snippetType="autosnippet"},
      fmta(
        [[
      \label{<>}
      ]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- HPHANTOM
    s({trig = "hpp", snippetType="autosnippet"},
      fmta(
        [[
      \hphantom{<>}
      ]],
        {
          d(1, get_visual),
        }
      )
    ),
    s({trig = "TODOO", snippetType="autosnippet"},
      fmta(
        [[\TODO{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    s({trig="nc"},
      fmta(
        [[\newcommand{<>}{<>}]],
        {
          i(1),
          i(2)
        }
      ),
      {condition = line_begin}
    ),
    s({trig="sii", snippetType="autosnippet"},
      fmta(
        [[\si{<>}]],
        {
          i(1),
        }
      )
    ),
    s({trig="qtt"},
      fmta(
        [[\qty{<>}{<>}]],
        {
          i(1),
          i(2)
        }
      )
    ),
    -- URL 
    s({trig="url"},
      fmta(
        [[\url{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- href command with URL in visual selection
    s({trig="LU", snippetType="autosnippet"},
      fmta(
        [[\href{<>}{<>}]],
        {
          d(1, get_visual),
          i(2)
        }
      )
    ),
    -- href command with text in visual selection
    s({trig="LL", snippetType="autosnippet"},
      fmta(
        [[\href{<>}{<>}]],
        {
          i(1),
          d(2, get_visual)
        }
      )
    ),
    -- HSPACE
    s({trig="hss", snippetType="autosnippet"},
      fmta(
        [[\hspace{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- VSPACE
    s({trig="vss", snippetType="autosnippet"},
      fmta(
        [[\vspace{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- SECTION
    s({trig="h1", snippetType="autosnippet"},
      fmta(
        [[\section{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- SUBSECTION
    s({trig="h2", snippetType="autosnippet"},
      fmta(
        [[\subsection{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- SUBSUBSECTION
    s({trig="h3", snippetType="autosnippet"},
      fmta(
        [[\subsubsection{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    s({trig="q"},
      {
        t("\\quad "),
      }
    ),
    s({trig="qq", snippetType="autosnippet"},
      {
        t("\\qquad "),
      }
    ),
    s({trig="npp", snippetType="autosnippet"},
      {
        t({"\\newpage", ""}),
      },
      {condition = line_begin}
    ),
    s({trig="which", snippetType="autosnippet"},
      {
        t("\\text{ for which } "),
      },
      {condition = tex.in_mathzone}
    ),
    s({trig="all", snippetType="autosnippet"},
      {
        t("\\text{ for all } "),
      },
      {condition = tex.in_mathzone}
    ),
    s({trig="and", snippetType="autosnippet"},
      {
        t("\\quad \\text{and} \\quad"),
      },
      {condition = tex.in_mathzone}
    ),
    s({trig="forall", snippetType="autosnippet"},
      {
        t("\\text{ for all } "),
      },
      {condition = tex.in_mathzone}
    ),
    s({trig = "toc", snippetType="autosnippet"},
      {
        t("\\tableofcontents"),
      },
      { condition = line_begin }
    ),
    s({trig="inff", snippetType="autosnippet"},
      {
        t("\\infty"),
      }
    ),
    s({trig="ii", snippetType="autosnippet"},
      {
        t("\\item "),
      },
      { condition = line_begin }
    ),
    s({trig = "--", snippetType="autosnippet"},
      {t('% --------------------------------------------- %')},
      {condition = line_begin}
    ),
    -- HLINE WITH EXTRA VERTICAL SPACE
    s({trig = "hl"},
      {t('\\hline {\\rule{0pt}{2.5ex}} \\hspace{-7pt}')},
      {condition = line_begin}
    ),
    s({trig=";a", snippetType="autosnippet"},
    {
      t("\\alpha"),
  }),
  s({trig=";b", snippetType="autosnippet"},
    {
      t("\\beta"),
  }),
  s({trig=";g", snippetType="autosnippet"},
    {
      t("\\gamma"),
  }),
  s({trig=";G", snippetType="autosnippet"},
    {
      t("\\Gamma"),
  }),
  s({trig=";d", snippetType="autosnippet"},
    {
      t("\\delta"),
  }),
  s({trig=";D", snippetType="autosnippet"},
    {
      t("\\Delta"),
  }),
  s({trig=";e", snippetType="autosnippet"},
    {
      t("\\epsilon"),
  }),
  s({trig=";ve", snippetType="autosnippet"},
    {
      t("\\varepsilon"),
  }),
  s({trig=";z", snippetType="autosnippet"},
    {
      t("\\zeta"),
  }),
  s({trig=";h", snippetType="autosnippet"},
    {
      t("\\eta"),
  }),
  s({trig=";o", snippetType="autosnippet"},
    {
      t("\\theta"),
  }),
  s({trig=";vo", snippetType="autosnippet"},
    {
      t("\\vartheta"),
  }),
  s({trig=";O", snippetType="autosnippet"},
    {
      t("\\Theta"),
  }),
  s({trig=";k", snippetType="autosnippet"},
    {
      t("\\kappa"),
  }),
  s({trig=";l", snippetType="autosnippet"},
    {
      t("\\lambda"),
  }),
  s({trig=";L", snippetType="autosnippet"},
    {
      t("\\Lambda"),
  }),
  s({trig=";m", snippetType="autosnippet"},
    {
      t("\\mu"),
  }),
  s({trig=";n", snippetType="autosnippet"},
    {
      t("\\nu"),
  }),
  s({trig=";x", snippetType="autosnippet"},
    {
      t("\\xi"),
  }),
  s({trig=";X", snippetType="autosnippet"},
    {
      t("\\Xi"),
  }),
  s({trig=";i", snippetType="autosnippet"},
    {
      t("\\pi"),
  }),
  s({trig=";I", snippetType="autosnippet"},
    {
      t("\\Pi"),
  }),
  s({trig=";r", snippetType="autosnippet"},
    {
      t("\\rho"),
  }),
  s({trig=";s", snippetType="autosnippet"},
    {
      t("\\sigma"),
  }),
  s({trig=";S", snippetType="autosnippet"},
    {
      t("\\Sigma"),
  }),
  s({trig=";t", snippetType="autosnippet"},
    {
      t("\\tau"),
  }),
  s({trig=";f", snippetType="autosnippet"},
    {
      t("\\phi"),
  }),
  s({trig=";vf", snippetType="autosnippet"},
    {
      t("\\varphi"),
  }),
  s({trig=";F", snippetType="autosnippet"},
    {
      t("\\Phi"),
  }),
  s({trig=";c", snippetType="autosnippet"},
    {
      t("\\chi"),
  }),
  s({trig=";p", snippetType="autosnippet"},
    {
      t("\\psi"),
  }),
  s({trig=";P", snippetType="autosnippet"},
    {
      t("\\Psi"),
  }),
  s({trig=";w", snippetType="autosnippet"},
    {
      t("\\omega"),
  }),
  s({trig=";W", snippetType="autosnippet"},
    {
      t("\\Omega"),
  }),
    -- TYPEWRITER i.e. \texttt
    s({trig = "([^%a])tt", regTrig = true, wordTrig = false, snippetType="autosnippet", priority=2000},
      fmta(
        "<>\\texttt{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      {condition = tex.in_text}
    ),
    -- ITALIC i.e. \textit
    s({trig = "([^%a])tii", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\textit{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      )
    ),
    -- BOLD i.e. \textbf
    s({trig = "tbb", snippetType="autosnippet"},
      fmta(
        "\\textbf{<>}",
        {
          d(1, get_visual),
        }
      )
    ),
    -- MATH ROMAN i.e. \mathrm
    s({trig = "([^%a])rmm", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\mathrm{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      )
    ),
    -- MATH CALIGRAPHY i.e. \mathcal
    s({trig = "([^%a])mcc", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\mathcal{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      )
    ),
    -- MATH BOLDFACE i.e. \mathbf
    s({trig = "([^%a])mbf", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\mathbf{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      )
    ),
    -- MATH BLACKBOARD i.e. \mathbb
    s({trig = "([^%a])mbb", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\mathbb{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      )
    ),
    -- REGULAR TEXT i.e. \text (in math environments)
    s({trig = "([^%a])tee", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta(
        "<>\\text{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      ),
      { condition = tex.in_mathzone }
    ),
}
