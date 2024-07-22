if vim.loader and vim.fn.has "nvim-0.9.1" == 1 then vim.loader.enable() end

vim.opt.clipboard = 'unnamedplus'

-- if vim.fn.has("wsl") == 1 then
--   if vim.fn.executable("wl-copy") == 0 then
--     print("wl-clipboard not found, clipboard integration won't work")
--   else
--     vim.g.clipboard = {
--       name = "wl-clipboard (wsl)",
--       copy = {
--         ["+"] = (function()
--           return vim.fn.systemlist('wl-paste --no-newline|sed -e "s/\r$//"', {''}, 1)
--         end),
--         ["*"] = (function()
--           return vim.fn.systemlist('wl-paste --primary --no-newline|sed -e "s/\r$//"', {''}, 1)
--         end),
--       },
--       cache_enabled = true
--     }
--   end
-- end

if vim.fn.has("wsl") then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf"
    },

    paste = {
      ["+"] = "win32yank.exe -o --crlf",
      ["*"] = "win32yank.exe -o --crlf"
    },
    cache_enable = 0,
  }
end

for _, source in ipairs {
  "astronvim.bootstrap",
  "astronvim.options",
  "astronvim.lazy",
  "astronvim.autocmds",
  "astronvim.mappings",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

if astronvim.default_colorscheme then
  if not pcall(vim.cmd.colorscheme, astronvim.default_colorscheme) then
    require("astronvim.utils").notify(
      ("Error setting up colorscheme: `%s`"):format(astronvim.default_colorscheme),
      vim.log.levels.ERROR
    )
  end
end

require("astronvim.utils").conditional_func(astronvim.user_opts("polish", nil, false), true)

vim.opt.wrap = true
vim.opt.linebreak = false
vim.opt.list = false

