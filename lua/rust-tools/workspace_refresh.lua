local M = {}

local function handler(err)
  if err then
    error(tostring(err))
  end
  vim.notify("Cargo workspace reloaded")
end

function M._reload_workspace_from_cargo_toml()
  local clients = vim.lsp.get_active_clients()

  for _, client in ipairs(clients) do
    if client.name == "rust_analyzer" then
      vim.notify("Reloading Cargo Workspace")
      client.request("rust-analyzer/reloadWorkspace", nil, handler, 0)
    end
  end
end

local function match_client(client)
  if client.name == "rust_analyzer" then
    local rd = client.config.root_dir
    local n = string.len(rd)
    local rd_ = string.sub(vim.fn.expand("%:p:h"), 1, n)
    return rd_ == rd
  end
  return false
end

function M.reload_workspace()
  local clients = vim.lsp.get_active_clients()

  for _, client in ipairs(clients) do
    if match_client(client) then
      vim.notify("Reloading Cargo Workspace")
      client.request("rust-analyzer/reloadWorkspace", nil, handler, 0)
    end
  end
end

return M
