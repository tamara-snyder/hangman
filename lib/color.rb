class String
  def red
    "\e[30m#{self}\e[0m"
  end

  def yellow
    "\e[33m#{self}\e[0m"
  end

  def magenta
    "\e[35m#{self}\e[0m"
  end

  def cyan
    "\e[36m#{self}\e[0m"
  end

  def gray
    "\e[37m#{self}\e[0m"
  end

  def bold
    "\e[1m#{self}\e[22m"
  end
end