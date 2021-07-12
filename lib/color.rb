class String
  def red
    "\e[31m#{self}\e[0m"
  end

  def green
    "\e[32m#{self}\e[0m"
  end

  def teal
    "\e[36m#{self}\e[0m"
  end

  def bold
    "\e[1m#{self}\e[22m"
  end
end