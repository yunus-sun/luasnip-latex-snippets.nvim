local ls = require("luasnip")
local t = ls.text_node
local i = ls.insert_node

local M = {}

function M.retrieve(not_math)
    local utils = require("luasnip-latex-snippets.util.utils")
    local pipe = utils.pipe

    local conds = require("luasnip.extras.expand_conditions")
    local condition = pipe({ conds.line_begin, not_math })

    local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
        condition = condition,
    }) --[[@as function]]

    local s = ls.extend_decorator.apply(ls.snippet, {
        condition = condition,
    }) --[[@as function]]

    return {
        -- s(
        --     { trig = "ali", name = "Align" },
        --     { t({ "\\begin{align*}", "\t" }), i(1), t({ "", ".\\end{align*}" }) }
        -- ),

        parse_snippet({ trig = "beg", name = "begin{} / end{}" }, "\\begin{$1}\n\t$0\n\\end{$1}"),
        parse_snippet({ trig = "case", name = "cases" }, "\\begin{cases}\n\t$1\n\\end{cases}"),

        parse_snippet({ trig = "ali", name = "align" }, "\\begin{align}\n\t$1\n\t\\label{equ:$2}\n\\end{align}$0"),
        parse_snippet({ trig = "fig", name = "figure" }, "\\begin{figure}[!h]\n\t% \\vspace{-2mm}\n\t% \\setlength{\\abovecaptionskip}{0.0cm}\n\t% \\setlength{\\belowcaptionskip}{0.0cm}\n\t\\captionsetup{width=\\linewidth}\n\t\\centerline{\\includegraphics[width=${1:.7}\\linewidth]{${2:figure_path}}\n\t\\caption{${3:figure_title}}\n\t\\label{fig:${4:figure_label}}\n\t% \\vspace{-2mm}\n\\end{figure}$0"),

        s({ trig = "bigfun", name = "Big function" }, {
            t({ "\\begin{align*}", "\t" }),
            i(1),
            t(":"),
            t(" "),
            i(2),
            t("&\\longrightarrow "),
            i(3),
            t({ " \\", "\t" }),
            i(4),
            t("&\\longmapsto "),
            i(1),
            t("("),
            i(4),
            t(")"),
            t(" = "),
            i(0),
            t({ "", ".\\end{align*}" }),
        }),
    }
end

return M
