local gl = require("galaxyline")
local gls = gl.section

--gl.short_line_list = {" "} -- keeping this table { } as empty will show inactive statuslines
local palette = {
	line_bg = "#1E222A",
}

local function colors(val)
	return function()
		local dark = {
			line_fg = "#ABE67E",
			line_bg = palette.line_bg,

			-- LEFT
			left_token_mode_fg = "#81A1C1",
			left_token_mode_bg = palette.line_bg,
			mode_fg = palette.line_bg,
			mode_bg = "#81A1C1",
			mode_separator_fg = palette.line_bg,
			mode_separator_bg = "#282C34",

			icon = "#282C34",
			file_fg = "#D8DEE9",
			file_bg = "#282C34",
			right_token_file_fg = "#282C34",
			right_token_file_bg = palette.line_bg,

			diff_add_fg = "#00FFF0",
			diff_add_bg = palette.line_bg,
			diff_mod_fg = "#FF8C00",
			diff_mod_bg = palette.line_bg,
			diff_rm_fg = "#FF4040",
			diff_rm_bg = palette.line_bg,

			symbols_fg = "#FFFFFF",
			symbols_bg = palette.line_bg,

			-- RIGHT
			lsp_client_fg = "#ABE67E",
			lsp_client_bg = palette.line_bg,

			error_fg = "#FF4040",
			error_bg = palette.line_bg,
			warn_fg = "#FF8C00",
			warn_bg = palette.line_bg,
			hint_fg = "#00FFF0",
			hint_bg = palette.line_bg,
			info_fg = "#FFFFFF",
			info_bg = palette.line_bg,

			branch_fg = "#ABE67E",
			branch_bg = palette.line_bg,

			left_separator_fg = "#81A1C1",
			left_separator_bg = palette.line_bg,
			left_token_fg = "#DF8890",
			left_token_bg = palette.line_bg,

			linecol_fg = "#282C34",
			linecol_bg = "#DF8890",
			separator_fg = "#81A1C1",
			separator_bg = "#81A1C1",
			buff_fg = palette.line_bg,
			buff_bg = "#81A1C1",

			right_token_fg = "#81A1C1",
			right_token_bg = palette.line_bg,
		}
		local light = {
			line_fg = "#ABE67E",
			line_bg = palette.line_bg,

			-- LEFT
			left_token_mode_fg = "#81A1C1",
			left_token_mode_bg = palette.line_bg,
			mode_fg = palette.line_bg,
			mode_bg = "#81A1C1",
			mode_separator_fg = palette.line_bg,
			mode_separator_bg = "#282C34",

			icon = "#282C34",
			file_fg = "#D8DEE9",
			file_bg = "#282C34",
			right_token_file_fg = "#282C34",
			right_token_file_bg = palette.line_bg,

			diff_add_fg = "#00FFF0",
			diff_add_bg = palette.line_bg,
			diff_mod_fg = "#FF8C00",
			diff_mod_bg = palette.line_bg,
			diff_rm_fg = "#FF4040",
			diff_rm_bg = palette.line_bg,

			symbols_fg = "#FFFFFF",
			symbols_bg = palette.line_bg,

			-- RIGHT
			lsp_client_fg = "#ABE67E",
			lsp_client_bg = palette.line_bg,

			error_fg = "#FF4040",
			error_bg = palette.line_bg,
			warn_fg = "#FF8C00",
			warn_bg = palette.line_bg,
			hint_fg = "#00FFF0",
			hint_bg = palette.line_bg,
			info_fg = "#FFFFFF",
			info_bg = palette.line_bg,

			branch_fg = "#ABE67E",
			branch_bg = palette.line_bg,

			left_separator_fg = "#81A1C1",
			left_separator_bg = palette.line_bg,
			left_token_fg = "#DF8890",
			left_token_bg = palette.line_bg,

			linecol_fg = "#282C34",
			linecol_bg = "#DF8890",
			separator_fg = "#81A1C1",
			separator_bg = "#81A1C1",
			buff_fg = palette.line_bg,
			buff_bg = "#81A1C1",

			right_token_fg = "#81A1C1",
			right_token_bg = palette.line_bg,
		}
		if vim.o.background ~= nil and vim.o.background == "light" then
			if light[val] ~= nil then
				return light[val]
			else
				return light.error
			end
		elseif vim.o.background ~= nil and vim.o.background == "dark" then
			if dark[val] ~= nil then
				return dark[val]
			else
				return dark.error
			end
		end
	end
end

gls.left[1] = {
	leftRounded = {
		provider = function()
			return ""
		end,
		highlight = { colors("left_token_mode_fg"), colors("left_token_mode_bg") },
	},
}

gls.left[2] = {
	ViMode = {
		provider = function()
			local alias = {
				n = "ℕ ",
				i = "𝕀",
				c = "ℂ ",
				v = "𝕍",
				[""] = "𝔹𝕍 ",
				V = "𝕃𝕍 ",
				R = "ℝ",
			}
			return alias[vim.fn.mode()]
		end,
		highlight = { colors("mode_fg"), colors("mode_bg") },
		separator = " ",
		separator_highlight = { colors("mode_separator_fg"), colors("mode_separator_bg") },
	},
}

gls.left[3] = {
	FileIcon = {
		provider = "FileIcon",
		condition = buffer_not_empty,
		highlight = { require("galaxyline.providers.fileinfo").get_file_icon_color, colors("icon") },
	},
}

gls.left[4] = {
	FileName = {
		provider = { "FileName", "FileSize" },
		condition = buffer_not_empty,
		highlight = { colors("file_fg"), colors("file_bg") },
	},
}

gls.left[5] = {
	teech = {
		provider = function()
			return ""
		end,
		separator = " ",
		highlight = { colors("right_token_file_fg"), colors("right_token_file_bg") },
	},
}

local checkwidth = function()
	local squeeze_width = vim.fn.winwidth(0) / 2
	if squeeze_width > 40 then
		return true
	end
	return false
end

gls.left[6] = {
	DiffAdd = {
		provider = "DiffAdd",
		condition = checkwidth,
		icon = "   ",
		highlight = { colors("diff_add_fg"), colors("diff_add_bg") },
	},
}

gls.left[7] = {
	DiffModified = {
		provider = "DiffModified",
		condition = checkwidth,
		icon = "≋ ",
		highlight = { colors("diff_mod_fg"), colors("diff_mod_bg") },
	},
}

gls.left[8] = {
	DiffRemove = {
		provider = "DiffRemove",
		condition = checkwidth,
		icon = " ",
		highlight = { colors("diff_rm_fg"), colors("diff_rm_bg") },
	},
}

-----------------------

gls.right[2] = {
	DiagnosticError = {
		provider = "DiagnosticError",
		icon = "  ",
		highlight = { colors("error_fg"), colors("error_bg") },
	},
	DiagnosticWarn = {
		provider = "DiagnosticWarn",
		icon = "  ",
		highlight = { colors("warn_fg"), colors("warn_bg") },
	},
}

gls.right[3] = {
	DiagnosticHint = {
		provider = "DiagnosticHint",
		icon = "  ",
		highlight = { colors("hint_fg"), colors("hint_bg") },
	},
	DiagnosticInfo = {
		provider = "DiagnosticInfo",
		icon = " ℹ ",
		highlight = { colors("info_fg"), colors("info_bg") },
	},
}

gls.right[4] = {
	GitIcon = {
		provider = function()
			return "  "
		end,
		condition = require("galaxyline.providers.vcs").check_git_workspace,
		highlight = { colors("branch_fg"), colors("branch_bg") },
	},
}

gls.right[5] = {
	GitBranch = {
		provider = "GitBranch",
		condition = require("galaxyline.providers.vcs").check_git_workspace,
		highlight = { colors("branch_fg"), colors("branch_bg") },
	},
}

gls.right[6] = {
	right_LeftRounded = {
		provider = function()
			return ""
		end,
		separator = " ",
		separator_highlight = { colors("left_separator_fg"), colors("left_separator_bg") },
		highlight = { colors("left_token_fg"), colors("left_token_bg") },
	},
}

gls.right[7] = {
	statusIcon = {
		provider = "LineColumn",
		highlight = { colors("linecol_fg"), colors("linecol_bg") },
	},
}

gls.right[8] = {
	PerCent = {
		provider = "BufferNumber",
		separator = " ",
		separator_highlight = { colors("separator_fg"), colors("separator_bg") },
		highlight = { colors("buff_fg"), colors("buff_bg") },
	},
}

gls.right[9] = {
	rightRounded = {
		provider = function()
			return ""
		end,
		highlight = { colors("right_token_fg"), colors("right_token_bg") },
	},
}
