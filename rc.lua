pcall(require, 'luarocks.loader')
require('defs')
require('awful.hotkeys_popup.keys')
require('awful.autofocus')


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
                    title = 'Oops, there were errors during startup!',
                    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal('debug::error', function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
                     title = 'Oops, an error happened!',
                     text = tostring(err) })
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. 'default/theme.lua')
--beautiful.init('./themes/theme.lua')

for s = 1, screen.count() do
	gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end

-- Import Keybinds
local keys = require('keys')
root.keys(keys.globalkeys)
root.buttons(keys.buttons)
keys.keystotags()

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier,
  awful.layout.suit.corner.nw,
  awful.layout.suit.floating,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}
-- }}}

-- Set rules
local rules = require('rules')
awful.rules.rules = rules.myrules

-- {{{ Menu
-- Create a main menu
-- TODO: make menu "disolve" when I click elsewhere
local myawesomemenu = {
   { 'hotkeys', function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { 'manual', apps.terminal .. ' -e man awesome' },
   { 'edit config', apps.editor .. ' ' .. awesome.conffile },
   { 'restart', awesome.restart },
   { 'quit', function() awesome.quit() end },
}

local mymainmenu = awful.menu({ items = {
    { 'awesome', myawesomemenu, beautiful.awesome_icon },
    { 'open terminal', apps.terminal }
  }
})

-- Awesome's default menu
local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menu to goto window/client
--local widget.gotomenu = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                     menu = widget.gotomenu })

-- Menu for window layouts
--local widget.layoutmenu = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                       menu = widget.layoutmenu })

-- Menubar configuration
menubar.utils.terminal = apps.terminal -- Set the apps.terminal for applications that require it
-- }}}

-- {{{ Wibar
local widget = require('widgets')

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == 'function' then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal('property::geometry', set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag({ '1', '2', '3', '4', '5', '6', '7', '8', '9' }, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.promptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.layoutbox = awful.widget.layoutbox(s)
  s.layoutbox:buttons(gears.table.join(
                        awful.button({ }, 1, function() awful.layout.inc( 1) end),
                        awful.button({ }, 3, function() awful.layout.inc(-1) end),
                        awful.button({ }, 4, function() awful.layout.inc( 1) end),
                        awful.button({ }, 5, function() awful.layout.inc(-1) end)))
  -- Create a taglist widget
  s.taglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = widget.taglist_buttons
  }

  -- Create a tasklist widget
  s.tasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = widget.tasklist_buttons,
    layout = {
      spacing_widget = {
        {
          forced_width = 2,
          forced_height = 13,
          thickness = 1,
          color = '#929292',
          widget = wibox.widget.separator
        },
        valign = 'center',
        halign = 'center',
        widget = wibox.container.place,
      },
      layout = wibox.layout.flex.horizontal,
    }
  }

  -- Create the wibox
  s.wibox = awful.wibar({ position = 'top', screen = s })

  -- Add widgets to the wibox
  s.wibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.taglist,
      s.promptbox,
    },

    -- Middle widgets
    s.tasklist,-- add separators

    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      -- add separators between widgets
      widget.keyboardlayout,-- make dropdown to select layout
      wibox.widget.systray(),-- make hideable
      widget.mem,-- make dropdown to view swap as well
      widget.cpu,-- make dropdown to view all cores
      --widget.netup, -- make dropdown graph
      --widget.netdown, -- make dropdown graph
      widget.textclock,-- make a dropdown calendar
      s.layoutbox,-- make dropdown to select from grid
    },
  }
end)
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal('manage', function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal('request::titlebars', function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
      awful.button({ }, 1, function()
        c:emit_signal('request::activate', 'titlebar', {raise = true})
        awful.mouse.client.move(c)
      end),
      awful.button({ }, 3, function()
        c:emit_signal('request::activate', 'titlebar', {raise = true})
        awful.mouse.client.resize(c)
      end)
    )

    awful.titlebar(c) : setup {
      { -- Left
        awful.titlebar.widget.iconwidget(c),
        buttons = buttons,
        layout  = wibox.layout.fixed.horizontal
      },
      { -- Middle
        { -- Title
          align  = 'center',
          widget = awful.titlebar.widget.titlewidget(c)
        },
        buttons = buttons,
        layout  = wibox.layout.flex.horizontal
      },
      { -- Right
        awful.titlebar.widget.floatingbutton  (c),
        awful.titlebar.widget.maximizedbutton (c),
        awful.titlebar.widget.stickybutton    (c),
        awful.titlebar.widget.ontopbutton     (c),
        awful.titlebar.widget.closebutton     (c),
        layout = wibox.layout.fixed.horizontal()
      },
      layout = wibox.layout.align.horizontal
  }
end)

-- notify me every 20 mins to look at something 20 feet away
-- source = 'https://awesomewm.org/doc/api/libraries/naughty.html#notify'
gears.timer {
  timeout = 1200,
  autostart = true,
  callback = function()
    naughty.notify({
      text='rest your eyes',
      preset = naughty.config.presets.critical,
      timeout=20, height=40, width=100
    })
  end
}

-- Gaps
beautiful.useless_gap = 3

-- only put border around focused window|client
--client.connect_signal('focus', function(c)
--  c.border_width = 2
--  c.border_color = '#0000AA'--= blue
--end)

-- Startup Apps
local run_on_startup = {
  'sxhkd &',
  'xmodmap ~/.config/X11/xmodmap &',
  'polychromatic-tray-applet',
  'picom',
  apps.terminal
}
-- sources = 'https://awesomewm.org/doc/api/libraries/awful.spawn.html#once',
--  'https://awesomewm.org/doc/api/libraries/awful.spawn.html#single_instance'
for _, app in pairs(run_on_startup) do
  --awful.spawn.single_instance(app, awful.rules.rules)
  awful.spawn.once(app, awful.rules.rules)
end

