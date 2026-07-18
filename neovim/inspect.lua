function I(...)
  for _, value in ipairs{...} do
    print(vim.inspect(value))
  end
end
