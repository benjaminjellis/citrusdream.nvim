local M = {}

---@param c string r g b of highlight
---@param bg string r g b of background
---@param a number between 0 and 1
---@return number
local blend = function(c, bg, a)
  return math.floor(a * tonumber("0x" .. c) + (1 - a) * tonumber("0x" .. bg))
end

---@param hex string hex with 3 channels, ex: #00ff00
---@param bg string hex with 3 channels, ex: #000000
---@param a number between 0 and 1
---@return string
local add_alpha = function(hex, bg, a)
  if not bg:match("^#%x%x%x%x%x%x$") then
    bg = "#121212"
  end
  local r1, g1, b1 = hex:sub(2, 3), hex:sub(4, 5), hex:sub(6, 7)
  local r2, g2, b2 = bg:sub(2, 3), bg:sub(4, 5), bg:sub(6, 7)
  return "#" .. string.format("%02x%02x%02x", blend(r1, r2, a), blend(g1, g2, a), blend(b1, b2, a))
end

---@param C table of colors
---@param O table of option
---@return table
M.theme = function(C, O)
  local editor = require("citrusdream.highlights.editor")(C, O)
  local rust = require("citrusdream.highlights.rust")(C, O)
  local fsharp = require("citrusdream.highlights.fsharp")(C, O)
  local lsp = require("citrusdream.highlights.lsp")(C, O)
  local semantictokens = require("citrusdream.highlights.semantictokens")(C, O)
  local ocaml = require("citrusdream.highlights.ocaml")(C, O)
  local snacks = require("citrusdream.highlights.snacks")(C, O)

  local rest = {
    Title = { fg = C.orange },

    -- debugging
    debugPC = { bg = C.background }, -- used for highlighting the current line in terminal-debug
    debugBreakpoint = { bg = C.background, fg = C.foreground }, -- used for breakpoint colors in terminal-debug

    -- illuminate
    illuminatedWord = { bg = C.black },
    illuminatedCurWord = { bg = C.bright_black },

    -- diff
    diffAdded = { fg = C.green },
    diffRemoved = { fg = C.red },
    diffChanged = { fg = C.bright_yellow },
    diffOldFile = { fg = C.yellow },
    diffNewFile = { fg = C.orange },
    diffFile = { fg = C.cyan },
    diffLine = { fg = C.bright_cyan },
    diffIndexLine = { fg = C.bright_black },
    DiffAdd = { bg = add_alpha(C.green, C.background, 0.20) }, -- diff mode: Added line |diff.txt|
    DiffChange = { bg = add_alpha(C.yellow, C.background, 0.20) }, -- diff mode: Changed line |diff.txt|
    DiffDelete = { bg = add_alpha(C.bright_red, C.background, 0.20) }, -- diff mode: Deleted line |diff.txt|
    DiffText = { bg = add_alpha(C.yellow, C.background, 0.35) }, -- diff mode: Changed text within a changed line |diff.txt|

    -- NeoVim
    healthError = { fg = C.red },
    healthSuccess = { fg = C.green },
    healthWarning = { fg = C.yellow },

    -- glyphs
    GlyphPalette1 = { fg = C.red },
    GlyphPalette2 = { fg = C.cyan },
    GlyphPalette3 = { fg = C.yellow },
    GlyphPalette4 = { fg = C.cyan },
    GlyphPalette6 = { fg = C.blue },
    GlyphPalette7 = { fg = C.white },
    GlyphPalette9 = { fg = C.red },

    -- rainbow
    rainbow1 = { fg = C.red },
    rainbow2 = { fg = C.blue },
    rainbow3 = { fg = C.lemon_yellow },
    rainbow4 = { fg = C.aurora },
    rainbow5 = { fg = C.orange },
    rainbow6 = { fg = C.bright_cyan },

    IblIndent = { fg = C.alt_background },
    IblScope = { fg = C.oxley },
    MiniIndentscopeSymbol = { fg = C.oxley },
    -- MiniIndentscopePrefix = { style = { "nocombine" } }, -- Make it invisible

    -- Treesitter highlights
    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { fg = C.white },
    ["@comment.error"] = { fg = C.black, bg = C.bright_red },
    ["@comment.warning"] = { fg = C.black, bg = C.yellow },
    ["@comment.todo"] = { fg = C.black, bg = C.bright_orange },
    ["@comment.note"] = { fg = C.black, bg = C.blue },
    ["TreesitterContextLineNumber"] = { fg = C.blue, bg = C.cursor },

    -- Punctuation
    ["@punctuation.delimiter"] = { link = "Delimiter" }, -- For delimiters ie: .
    ["@punctuation.bracket"] = { fg = C.orange }, -- For brackets and parenthesis.
    ["@punctuation.special"] = { link = "Special" }, -- For special punctutation that does not fall in the categories before.

    ["@module"] = { fg = C.yellow, italic = O.italic }, -- For identifiers referring to modules and namespaces.
    ["@module.builtin"] = { link = "@module" },
    ["@label"] = { fg = C.bright_orange },
    ["@macro"] = { link = "Macro" },

    -- Literals
    ["@string"] = { link = "String" }, -- For strings.
    ["@string.regexp"] = { fg = C.bright_orange }, -- For regexes.
    ["@string.escape"] = { fg = C.bright_red }, -- For escape characters within a string.
    ["@string.special"] = { link = "Special" }, -- other special strings (e.g. dates)
    ["@string.special.symbol"] = { fg = C.yellow },
    ["@string.special.path"] = { fg = C.aurora },
    ["string.special.url"] = { fg = C.aurora, underline = true }, -- urls, links and emails

    ["@character"] = { link = "Character" }, -- character literals
    ["@character.special"] = { link = "SpecialChar" }, -- special characters (e.g. wildcards)

    ["@boolean"] = { link = "Boolean" }, -- For booleans.
    ["@number"] = { link = "Number" }, -- For all numbers
    ["@number.float"] = { link = "Float" }, -- For floats.

    -- Functions
    ["@function"] = { link = "Function" }, -- For function (calls and definitions).
    ["@function.builtin"] = { link = "Function" }, -- For builtin functions: table.insert in Lua.
    ["@function.call"] = { link = "Function" }, -- function calls
    ["@function.macro"] = { fg = C.violet }, -- For macro defined functions (calls and definitions): each macro_rules in RusC.
    ["@function.method"] = { link = "Function" }, -- For method calls and definitions.
    ["@function.method.call"] = { link = "Function" }, -- method calls
    ["@constructor"] = { fg = C.bright_yellow }, -- For constructor calls and definitions: = { } in Lua, and Java constructors.
    ["@operator"] = { link = "Operator" }, -- For any operator: +, but also -> and * in C.

    -- Keywords
    ["@keyword"] = { link = "Keyword" }, -- For keywords that don't fall in previous categories.
    ["@keyword.coroutine"] = { fg = C.lemon_yellow }, -- for key words like `async`
    ["@keyword.function"] = { fg = C.lemon_yellow }, -- For keywords used to define a function.
    ["@keyword.operator"] = { link = "Operator" }, -- For new keyword operator.
    ["@keyword.return"] = { fg = C.bright_yellow },
    ["@keyword.import"] = { link = "Include" }, -- For includes.
    ["@keyword.storage"] = { link = "StorageClass" }, -- visibility/life-time/etc. modifiers (e.g. `static`).
    ["@keyword.repeat"] = { link = "Repeat" }, -- For keywords related to loop.
    ["@keyword.exception"] = { link = "Exception" }, -- For exception keywords.
    ["@keyword.conditional"] = { link = "Conditional" }, -- For keywords related to conditional,
    ["@keyword.conditional.ternary"] = { fg = C.bright_yellow }, -- e.g. ? or :
    ["@keyword.directive"] = { link = "PreProc" }, -- Various preprocessor directive & shebangs.
    ["@keyword.directive.define"] = { link = "Define" }, -- Preprocessor definition directive.
    ["@keyword.debug"] = { link = "Debug" },

    -- JS & derivative
    ["@keyword.export"] = { fg = C.bright_cyan },
    ["@lsp.typemod.function.defaultLibrary.javascript"] = { fg = C.bright_green },

    -- Types
    ["@type"] = { link = "Type" }, -- For types.
    ["@type.builtin"] = { link = "@type", italic = O.italic }, -- For builtin types.
    ["@type.definition"] = { link = "@type" }, -- type definitions (e.g. `typedef` in C)
    ["@type.qualifier"] = { link = "Constant" }, -- type qualifiers (e.g. `const`)

    ["@attribute"] = { link = "Constant" }, -- attribute annotations (e.g. Python decorators)
    ["@property"] = { fg = C.bright_cyan }, -- Same as TSField.

    -- Identifiers
    ["@variable"] = { fg = C.very_bright_green }, -- Any variable name that does not have another highlight.
    ["@variable.builtin"] = { link = "Identifier" }, -- Variable names that are defined by the languages, like this or self.
    ["@variable.parameter"] = { fg = C.bright_green, italic = O.italic }, -- For parameters of a function.
    ["@parameter"] = { fg = C.bright_green, italic = O.italic }, -- For the variables inside a function that are parameters of the function
    ["@variable.member"] = { fg = C.bright_cyan }, -- For fields

    ["@constant"] = { link = "Constant" }, -- For constants
    ["@constant.builtin"] = { link = "Constant" }, -- For constant that are built in the language: nil in Lua.
    ["@constant.macro"] = { link = "Macro" }, -- For constants that are defined by macros: NULL in C.

    -- Markup
    ["@markup"] = { fg = C.bright_white }, -- For strings considerated text in a markup language.
    ["@markup.strong"] = { fg = C.white, bold = true },
    ["@markup.italic"] = { fg = C.white, italic = O.italic },
    ["@markup.strikethrough"] = { fg = C.white, strikethrough = true },
    ["@markup.underline"] = { link = "Underline" },
    ["@markup.heading"] = { fg = C.blue, bold = O.bold }, -- titles like: # Example.
    ["@markup.math"] = { fg = C.blue },
    ["@markup.environment"] = { fg = C.bright_orange }, -- Text indicating the type of an environment.
    ["@markup.link"] = { link = "Tag" },
    ["@markup.link.label"] = { fg = C.cyan, underline = true },
    ["@markup.link.url"] = { fg = C.bright_orange, underline = true },
    ["@markup.raw"] = { fg = C.lemon_yellow }, -- used for inline code in markdown and for doc in python.
    ["@markup.raw.block"] = { fg = C.baby_blue }, -- used for inline code in markdown and for doc in python.
    ["@markup.list"] = { link = "Special" },
    ["@markup.list.checked"] = { fg = C.green },
    ["@markup.list.unchecked"] = { fg = C.white },

    -- Diff
    ["@diff.plus"] = { link = "diffAdded" },
    ["@diff.minus"] = { link = "diffRemoved" },
    ["@diff.delta"] = { link = "diffChanged" },

    -- Misc
    ["@error"] = { link = "Error" },

    -- Tags
    ["@tag"] = { fg = C.blue }, -- Tags like html tag names.
    ["@tag.attribute"] = { fg = C.yellow, italic = O.italic }, -- Tags like html tag names.
    ["@tag.delimiter"] = { fg = C.red }, -- Tag delimiter like < > /

    -- Language specific:
    -- Markdown
    ["@markup.heading.1.markdown"] = { link = "rainbow1" },
    ["@markup.heading.2.markdown"] = { link = "rainbow2" },
    ["@markup.heading.3.markdown"] = { link = "rainbow3" },
    ["@markup.heading.4.markdown"] = { link = "rainbow4" },
    ["@markup.heading.5.markdown"] = { link = "rainbow5" },
    ["@markup.heading.6.markdown"] = { link = "rainbow6" },

    -- Css
    ["@property.css"] = { fg = C.bright_orange },
    ["@property.id.css"] = { fg = C.cyan },
    ["@property.class.css"] = { fg = C.yellow },
    ["@type.css"] = { fg = C.blue },
    ["@type.tag.css"] = { fg = C.bright_orange },
    ["@string.plain.css"] = { fg = C.yellow },
    ["@number.css"] = { fg = C.yellow },

    -- Toml
    ["@property.toml"] = { fg = C.cyan }, -- Differentiates between string and properties

    -- Json
    ["@label.json"] = { fg = C.bright_green }, -- For labels: label: in C and :label: in Lua.

    -- Lua
    ["@constructor.lua"] = { fg = C.orange }, -- For constructor calls and definitions: = { } in Lua, and Java constructors.
    ["@lsp.typemod.function.defaultLibrary.lua"] = { fg = C.blue },

    -- Typescript
    ["@constructor.typescript"] = { fg = C.bright_green },

    -- TSX (Typescript React)
    ["@constructor.tsx"] = { fg = C.bright_green },
    ["@tag.attribute.tsx"] = { fg = C.bright_yellow, italic = O.italic },

    -- Cpp
    ["@property.cpp"] = { fg = C.bright_orange },

    -- Yaml
    ["@variable.member.yaml"] = { fg = C.bright_blue }, -- For fields.

    -- Ruby
    ["@string.special.symbol.ruby"] = { fg = C.bright_yellow },

    -- Php
    ["@function.method.php"] = { link = "Function" },
    ["@function.method.call.php"] = { link = "Function" },

    -- Python
    ["@string.documentation.python"] = { fg = C.baby_blue },

    -- Haskell
    ["@operator.haskell"] = { fg = C.bright_yellow },

    -- csv
    csvCol0 = { fg = C.bright_orange },
    csvCol1 = { fg = C.bright_green },
    csvCol2 = { fg = C.bright_yellow },
    csvCol3 = { fg = C.bright_red },
    csvCol4 = { fg = C.bright_blue },
    csvCol5 = { fg = C.bright_cyan },
    csvCol6 = { fg = C.lemon_yellow },
    csvCol7 = { fg = C.aurora },
    csvCol8 = { fg = C.red },

    -- QuickFix
    QuickFixLine = { bg = C.cursor, bold = O.bold }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    qfFileName = { fg = C.bright_orange },
    qfLineNr = { fg = C.yellow },

    -- Cmp
    CmpItemAbbr = { fg = C.bright_white },
    CmpItemAbbrDeprecated = { fg = C.foreground, strikethrough = true },
    CmpItemKind = { fg = C.cyan },
    CmpItemMenu = { fg = C.white },
    CmpItemAbbrMatch = { fg = C.bright_green, bold = O.bold },
    CmpItemAbbrMatchFuzzy = { fg = C.bright_green, bold = O.bold },
    CmpSel = { fg = C.black, bg = add_alpha(C.baby_blue, C.background, 0.9), bold = O.bold }, -- Visual mode selection

    -- kind colors
    CmpItemKindSnippet = { fg = C.bright_cyan },
    CmpItemKindKeyword = { fg = C.lemon_yellow },
    CmpItemKindText = { fg = C.lemon_yellow },
    CmpItemKindMethod = { fg = C.lime_green },
    CmpItemKindConstructor = { fg = C.lime_green },
    CmpItemKindFunction = { fg = C.lime_green },
    CmpItemKindFolder = { fg = C.orange },
    CmpItemKindModule = { fg = C.yellow },
    CmpItemKindConstant = { fg = C.aurora },
    CmpItemKindField = { fg = C.bright_cyan },
    CmpItemKindProperty = { fg = C.bright_cyan },
    CmpItemKindEnum = { fg = C.aurora },
    CmpItemKindUnit = { fg = C.green },
    CmpItemKindClass = { fg = C.bright_orange },
    CmpItemKindVariable = { fg = C.blue },
    CmpItemKindFile = { fg = C.cyan },
    CmpItemKindInterface = { fg = C.yellow },
    CmpItemKindColor = { fg = C.red },
    CmpItemKindReference = { fg = C.red },
    CmpItemKindEnumMember = { fg = C.red },
    CmpItemKindStruct = { fg = C.bright_orange },
    CmpItemKindValue = { fg = C.blue },
    CmpItemKindEvent = { fg = C.cyan },
    CmpItemKindOperator = { fg = C.cyan },
    CmpItemKindTypeParameter = { fg = C.cyan },
    CmpItemKindCopilot = { fg = C.bright_orange },

    -- Gitsigns
    SignAdd = { fg = C.bright_green, bg = C.none },
    SignChange = { fg = C.yellow, bg = C.none },
    SignDelete = { fg = C.red, bg = C.none },
    GitSignsAdd = { fg = C.green, bg = C.none },
    GitSignsChange = { fg = C.yellow, bg = C.none },
    GitSignsDelete = { fg = C.red, bg = C.none },
    GitSignsAddInline = { fg = C.green, bg = C.none },
    GitSignsChangeInline = { fg = C.yellow, bg = C.none },
    GitSignsDeleteInline = { fg = C.red, bg = C.none },

    -- Fidget
    FidgetTask = {
      fg = C.aurora,
      bg = C.lemon_yellow,
    },
    FidgetTitle = { fg = C.baby_blue },

    -- Rainbow Delimiter
    RainbowDelimiterRed = { fg = C.bright_red },
    RainbowDelimiterYellow = { fg = C.bright_yellow },
    RainbowDelimiterBlue = { fg = C.blue },
    RainbowDelimiterOrange = { fg = C.orange },
    RainbowDelimiterGreen = { fg = C.bright_green },
    RainbowDelimiterViolet = { fg = C.violet },
    RainbowDelimiterCyan = { fg = C.bright_cyan },

    -- Telescope
    TelescopePromptPrefix = { fg = C.bright_yellow, bg = C.background },
    TelescopeSelectionCaret = { fg = C.bright_yellow, bg = C.visual, bold = O.bold },
    TelescopePromptNormal = { bg = C.background },
    TelescopeResultsNormal = { bg = C.background },
    TelescopePreviewNormal = { bg = C.background },
    TelescopePromptBorder = { fg = C.lime_green, bg = C.background },
    TelescopeResultsBorder = { fg = C.lime_green, bg = C.background },
    TelescopePreviewBorder = { fg = C.lime_green, bg = C.background },
    TelescopePromptTitle = { fg = C.black, bg = C.lime_green },
    TelescopeResultsTitle = { fg = C.black, bg = C.lime_green },
    TelescopePreviewTitle = { fg = C.black, bg = C.lime_green },
    TelescopeSelection = { bg = C.visual },

    -- NvimTree
    NvimTreeFolderName = { fg = C.bright_orange },
    NvimTreeFolderIcon = { fg = C.bright_orange },
    NvimTreeNormal = { fg = C.bright_white },
    NvimTreeOpenedFolderName = { fg = C.aurora, bold = O.bold },
    NvimTreeEmptyFolderName = { fg = C.bright_black },
    NvimTreeIndentMarker = { fg = C.baby_blue },
    NvimTreeWinSeparator = { fg = C.baby_blue, bg = C.background },
    NvimTreeRootFolder = { fg = C.bright_yellow, bold = O.bold },
    NvimTreeSymlink = { fg = C.blue },
    NvimTreeStatuslineNc = { fg = C.bright_orange, bg = C.background },
    NvimTreeGitDirty = { fg = C.red },
    NvimTreeGitNew = { fg = C.cyan },
    NvimTreeGitDeleted = { fg = C.red },
    NvimTreeSpecialFile = { fg = C.lemon_yellow },
    NvimTreeImageFile = { fg = C.baby_blue },
    NvimTreeOpenedFolderIcon = { fg = C.aurora },
    NvimTreeFolderArrowOpen = { fg = C.aurora },
    NvimTreeFolderArrowClosed = { fg = C.bright_orange },
    NvimTreeExecFile = { fg = C.bright_white },

    -- Alpha
    AlphaShortcut = { fg = C.bright_yellow },
    AlphaHeader = { fg = C.orange },
    AlphaHeaderLabel = { fg = C.cyan },
    AlphaButtons = { fg = C.blue },
    AlphaFooter = { fg = C.bright_red },

    -- Dashboard
    DashboardHeader = { fg = C.orange },
    DashboardFooter = { fg = C.yellow },

    -- Dashboard Hyper Theme
    DashboardProjectTitle = { fg = C.lime_green },
    DashboardProjectTitleIcon = { fg = C.lime_green },
    DashboardProjectIcon = { fg = C.blue },
    DashboardMruTitle = { fg = C.bright_cyan },
    DashboardMruIcon = { fg = C.bright_cyan },
    DashboardFiles = { fg = C.white },
    DashboardShortCutIcon = { fg = C.yellow },

    --  Dashboard Doom Theme
    DashboardDesc = { fg = C.bright_blue },
    DashboardIcon = { fg = C.bright_blue },
    DashboardKey = { fg = C.lime_green },
    DashboardShortCut = { fg = C.bright_yellow },

    -- Whichkey
    WhichKey = { link = "NormalFloat" },
    WhichKeyBorder = { link = "FloatBorder" },
    WhichKeyGroup = { fg = C.bright_cyan },
    WhichKeySeparator = { fg = C.bright_red },
    WhichKeyDesc = { fg = C.yellow },
    WhichKeyValue = { fg = C.green },

    -- Flash
    FlashBackdrop = { fg = C.foreground },
    FlashLabel = { fg = C.yellow, bg = C.background, bold = O.bold },
    FlashMatch = { fg = C.green, bg = C.background },
    FlashCurrent = { fg = C.orange, bg = C.background },
    FlashPrompt = { link = "NormalFloat" },

    -- Lazy
    LazyH1 = { fg = C.lime_green, bg = C.visual, bold = O.bold },
    LazyButton = { fg = C.foreground, bg = C.visual, bold = O.bold },
    LazyButtonActive = { fg = C.lime_green, bg = C.cursor, bold = O.bold },
    LazySpecial = { fg = C.blue },

    -- Navic
    NavicIconsFile = { fg = C.blue, bg = C.background },
    NavicIconsModule = { fg = C.blue, bg = C.background },
    NavicIconsNamespace = { fg = C.blue, bg = C.background },
    NavicIconsPackage = { fg = C.blue, bg = C.background },
    NavicIconsClass = { fg = C.yellow, bg = C.background },
    NavicIconsMethod = { fg = C.blue, bg = C.background },
    NavicIconsProperty = { fg = C.green, bg = C.background },
    NavicIconsField = { fg = C.green, bg = C.background },
    NavicIconsConstructor = { fg = C.blue, bg = C.background },
    NavicIconsEnum = { fg = C.green, bg = C.background },
    NavicIconsInterface = { fg = C.yellow, bg = C.background },
    NavicIconsFunction = { fg = C.blue, bg = C.background },
    NavicIconsVariable = { fg = C.orange, bg = C.background },
    NavicIconsConstant = { fg = C.cyan, bg = C.background },
    NavicIconsString = { fg = C.orange, bg = C.background, italic = O.italic, bold = O.bold },
    NavicIconsNumber = { fg = C.cyan, bg = C.background },
    NavicIconsBoolean = { fg = C.orange, bg = C.background },
    NavicIconsArray = { fg = C.cyan, bg = C.background },
    NavicIconsObject = { fg = C.cyan, bg = C.background },
    NavicIconsKey = { fg = C.yellow, bg = C.background, italic = O.italic, bold = O.bold },
    NavicIconsNull = { fg = C.orange, bg = C.background },
    NavicIconsEnumMember = { fg = C.blue, bg = C.background },
    NavicIconsStruct = { fg = C.blue, bg = C.background },
    NavicIconsEvent = { fg = C.blue, bg = C.background },
    NavicIconsOperator = { fg = C.cyan, bg = C.background },
    NavicIconsTypeParameter = { fg = C.blue, bg = C.background },
    NavicText = { fg = C.bright_white, bg = C.background, italic = O.italic },
    NavicSeparator = { fg = C.red, bg = C.background },

    -- Neo-tree
    NeoTreeDimText = { fg = C.white },
    NeoTreeDirectoryIcon = { fg = C.bright_orange },
    NeoTreeDirectoryName = { fg = C.bright_orange },
    NeoTreeFileName = { fg = C.bright_white },
    NeoTreeTitleBar = { fg = C.black, bg = C.blue },
    NeoTreeGitAdded = { fg = C.green },
    NeoTreeGitConflict = { fg = C.red },
    NeoTreeGitDeleted = { fg = C.red },
    NeoTreeGitIgnored = { fg = C.comment },
    NeoTreeGitModified = { fg = C.lemon_yellow },
    NeoTreeGitUnstaged = { fg = C.aurora },
    NeoTreeGitUntracked = { fg = C.bright_white },
    NeoTreeGitStaged = { fg = C.green },
    NeoTreeHiddenByName = { fg = C.bright_black },
    NeoTreeIndentMarker = { fg = C.baby_blue },
    NeoTreeRootName = { fg = C.white },
    NeoTreeDotfile = { fg = C.bright_orange },
  }

  return vim.tbl_extend("force", editor, rest, rust, fsharp, lsp, semantictokens, ocaml, snacks)
end

return M
