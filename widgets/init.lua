widget, cpu_now, mem_now, net_now = widget, cpu_now, mem_now, net_now
require('defs')
local M={}

-- widget separator
M.separator = ' | '

-- show the date and time
M.textclock = wibox.widget.textclock()

-- Keyboard map indicator and switcher
M.keyboardlayout = awful.widget.keyboardlayout()

-- show cpu usage
M.cpu = lain.widget.cpu {
  settings = function()
    widget:set_markup("Cpu: " .. cpu_now.usage .. "%")
  end
}

-- show mem usage
M.mem = lain.widget.mem {
  settings = function()
    -- in MegaBytes
    widget:set_markup("Mem: M " .. mem_now.used .. " ")
    -- in percentage
    --widget:set_markup("Mem: %" .. mem_now.perc .. " ")
  end
}

-- show swap usage
M.swp = lain.widget.mem {
  settings = function()
    widget:set_markup("Swp: M " .. mem_now.swapused .. " ")
  end
}

-- source: "https://github.com/lcpz/lain/wiki/net"
-- show network download speed
M.netdown = wibox.widget.textbox()

-- show network upload speed
M.netup = lain.widget.net {
  settings = function()
    widget:set_markup("Up: " .. net_now.sent)
    M.netdown:set_markup("Dwn: " .. net_now.received)
  end
}

-- Create a wibox for each screen and add it
M.taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t) end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

M.tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal(
        'request::activate',
        'tasklist',
        {raise = true}
      )
    end
  end),
  awful.button({ }, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({ }, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function()
    awful.client.focus.byidx(-1)
  end)
)

return M
