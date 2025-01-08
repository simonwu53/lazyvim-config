return {
	{ 'AndreM222/copilot-lualine' },
	{
		'nvim-lualine/lualine.nvim',
		dependencies = {
			{ 'dokwork/lualine-ex' },
			{ 'nvim-lua/plenary.nvim' },
			{ 'kyazdani42/nvim-web-devicons' },
		},

		event = "VeryLazy",

		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,

		opts = function()
			-- PERF: we don't need this lualine require madness 🤷
			local lualine_require = require("lualine_require")
			lualine_require.require = require

			local icons = LazyVim.config.icons

			vim.o.laststatus = vim.g.lualine_laststatus

			-- colors
			local colors = {
				rosewater = "#f4dbd6",
				flamingo = "#f0c6c6",
				pink = "#f5bde6",
				mauve = "#c6a0f6",
				red = "#f7768e",
				maroon = "#ee99a0",
				peach = "#ff9e64",
				yellow = "#e0af68",
				green = "#a6da95",
				teal = "#8bd5ca",
				sky = "#91d7e3",
				sapphire = "#7dc4e4",
				blue = "#7aa2f7",
				lavender = "#b7bdf8",
				text = "#cad3f5",
				subtext1 = "#b8c0e0",
				subtext0 = "#a5adcb",
				overlay2 = "#939ab7",
				overlay1 = "#8087a2",
				overlay0 = "#6e738d",
				surface2 = "#5b6078",
				surface1 = "#494d64",
				surface0 = "#363a4f",
				base = "#24273a",
				mantle = "#1e2030",
				crust = "#181926",
			}

			local theme = {
				normal = {
					a = { fg = colors.peach, bg = colors.surface2 },
					b = { fg = colors.blue, bg = colors.surface2 },
					c = { fg = colors.teal },
				},
				insert = { a = { fg = colors.blue, bg = colors.surface2 } },
				visual = { a = { fg = colors.text, bg = colors.surface2 } },
				replace = { a = { fg = colors.yellow, bg = colors.surface2 } },
				command = { a = { fg = colors.red, bg = colors.surface2 } },
				inactive = {
					a = { fg = colors.green },
					b = { fg = colors.blue },
					c = { fg = colors.green },
				},
			}

			-- define components
			local branch = {
				"branch",
				draw_empty = true,
				color = { fg = colors.overlay1 },
				separator = '|'
			}

			local diagnostics = {
				"diagnostics",
				color = { fg = colors.lavender },
				symbols = {
					error = icons.diagnostics.Error,
					warn = icons.diagnostics.Warn,
					info = icons.diagnostics.Info,
					hint = icons.diagnostics.Hint,
				},
			}

			local diff = {
				"diff",
				color = { fg = colors.mauve },
				symbols = {
					added = icons.git.added,
					modified = icons.git.modified,
					removed = icons.git.removed,
				},
				source = function()
					local gitsigns = vim.b.gitsigns_status_dict
					if gitsigns then
						return {
							added = gitsigns.added,
							modified = gitsigns.changed,
							removed = gitsigns.removed,
						}
					end
				end,
				separator = '|'
			}

			local filename = {
				"filename",
				color = { fg = colors.mauve },
				file_status = true, -- Displays file status (readonly status, modified status)
				newfile_status = true, -- Display new file status (new file means no write after created)
				path = 1,
				-- 0: Just the filename
				-- 1: Relative path
				-- 2: Absolute path
				-- 3: Absolute path, with tilde as the home directory
				-- 4: Filename and parent dir, with tilde as the home directory

				shorting_target = 40, -- Shortens path to leave 40 spaces in the window
				-- for other components. (terrible name, any suggestions?)
				symbols = {
					modified = "󰷥", -- Text to show when the file is modified.
					readonly = "", -- Text to show when the file is non-modifiable or readonly.
					unnamed = " - No Name", -- Text to show for unnamed buffers.
					newfile = " - New File",
				},
				separator = '→'
			}

			local encoding = {
				"encoding",
			}

			local filetype = {
				"filetype",
				icon_only = true,
				padding = { left = 1, right = 0 }
			}

			local copilot = {
			  'copilot',
			  show_colors = true
			}

			-- Lualine Options
			local opts = {
				options = {
					theme=theme,
					component_separators = '',
					section_separators = { left = '', right = '' },
				},
				sections = {
					lualine_a = {
						'mode',
					},
					lualine_b = {
						branch,
						diff,
						diagnostics,
					},
					lualine_c = {
						filename,
					},
					lualine_x = {
						Snacks.profiler.status(),
						copilot,
						-- stylua: ignore
						{
							function() return require("noice").api.status.command.get() end,
							cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
							color = function() return { fg = Snacks.util.color("Statement") } end,
						},
						-- stylua: ignore
						{
							function() return require("noice").api.status.mode.get() end,
							cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
							color = function() return { fg = Snacks.util.color("Constant") } end,
						},
						-- stylua: ignore
						{
							function() return "  " .. require("dap").status() end,
							cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
							color = function() return { fg = Snacks.util.color("Debug") } end,
						},
						-- stylua: ignore
						{
							require("lazy.status").updates,
							cond = require("lazy.status").has_updates,
							color = function() return { fg = Snacks.util.color("Special") } end,
						},
					},
					lualine_y = {
						{ "progress", separator = '|', padding = { left = 1, right = 1 } },
						{
							"location",
							padding = { left = 1, right = 1 },
							fmt = function(str)
								local line, col = str:match("(%d+):(%d+)")
								return string.format("Ln %d, Col %d", tonumber(line), tonumber(col))
							end,
							separator = '|',
						},
						encoding,
					},
					lualine_z = {
						filetype,
						{
							'ex.lsp.single',
							icons = {
								lsp_is_off = '⏾',
								['null-ls'] = { '⭘' }
							},
						}
					},
				},
				inactive_sections = {
					lualine_a = { 'filename' },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { 'location' },
				},
				extensions = { "neo-tree", "lazy", "fzf" },
			}

			-- do not add trouble symbols if aerial is enabled
			-- And allow it to be overriden for some buffer types (see autocmds)
			if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
				local trouble = require("trouble")
				local symbols = trouble.statusline({
					mode = "symbols",
					groups = {},
					title = false,
					filter = { range = true },
					format = "{kind_icon}{symbol.name:Normal}",
					hl_group = "lualine_c_normal",
				})
				table.insert(opts.sections.lualine_c, {
					symbols and symbols.get,
					cond = function()
						return vim.b.trouble_lualine ~= false and symbols.has()
					end,
				})
			end

			return opts
		end
	}
}
