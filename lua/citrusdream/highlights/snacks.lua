return function(C, O)
  return {
    -- SnacksNormal = { link = "NormalFloat" },
    SnacksWinBar = { link = "Title" },
    -- SnacksBackdrop = { fg = C.overlay0 },
    -- SnacksNormalNC = { link = "NormalFloat" },
    -- SnacksWinBarNC = { link = "SnacksWinBar" },

    SnacksNotifierInfo = { fg = C.blue },
    SnacksNotifierIconInfo = { fg = C.blue },
    SnacksNotifierTitleInfo = { fg = C.blue, italic = O.italic },
    -- SnacksNotifierFooterInfo = { link = "DiagnosticInfo" },
    SnacksNotifierBorderInfo = { fg = C.blue },
    SnacksNotifierWarn = { fg = C.yellow },
    SnacksNotifierIconWarn = { fg = C.yellow },
    SnacksNotifierTitleWarn = { fg = C.yellow, italic = O.italic },
    SnacksNotifierBorderWarn = { fg = C.yellow },
    -- SnacksNotifierFooterWarn = { link = "DiagnosticWarn" },
    -- SnacksNotifierDebug = { fg = C.peach },
    -- SnacksNotifierIconDebug = { fg = C.peach },
    -- SnacksNotifierTitleDebug = { fg = C.peach, style = { "italic" } },
    -- SnacksNotifierBorderDebug = { fg = C.peach },
    -- SnacksNotifierFooterDebug = { link = "DiagnosticHint" },
    SnacksNotifierError = { fg = C.red },
    SnacksNotifierIconError = { fg = C.red },
    SnacksNotifierTitleError = { fg = C.red, italic = O.italic },
    SnacksNotifierBorderError = { fg = C.red },
    -- SnacksNotifierFooterError = { link = "DiagnosticError" },
    -- SnacksNotifierTrace = { fg = C.rosewater },
    -- SnacksNotifierIconTrace = { fg = C.rosewater },
    -- SnacksNotifierTitleTrace = { fg = C.rosewater, style = { "italic" } },
    -- SnacksNotifierBorderTrace = { fg = C.rosewater },
    -- SnacksNotifierFooterTrace = { link = "DiagnosticHint" },

    SnacksDashboardNormal = { link = "Normal" },
    SnacksDashboardDesc = { fg = C.lime_green },
    -- SnacksDashboardFile = { fg = C.lavender },
    -- SnacksDashboardDir = { link = "NonText" },
    SnacksDashboardFooter = { fg = C.yellow, italic = O.italic },
    SnacksDashboardHeader = { fg = C.orange },
    SnacksDashboardIcon = { fg = C.lime_green, bold = true },
    SnacksDashboardKey = { fg = C.violet },
    -- SnacksDashboardTerminal = { link = "SnacksDashboardNormal" },
    -- SnacksDashboardSpecial = { link = "Special" },
    SnacksDashboardTitle = { link = "Title" },
  }
end
