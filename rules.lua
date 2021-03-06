-- define rules
local M={}
require('defs')
local keys = require('keys')
local clientkeys = keys.clientkeys
local clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ keys.modkey }, 1, function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.move(c)
    end),
    awful.button({ keys.modkey }, 3, function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.resize(c)
    end)
)

-- Rules to apply to new clients (through the "manage" signal).
M.myrules = {--"https://awesomewm.org/doc/api/libraries/awful.M.html"
    -- All clients will match this rule.
    { rule = { },
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen
      }
    },

    -- Floating clients.
    {rule_any = {
      instance = {
        "DTA",  -- Firefox addon DownThemAll.
        "copyq",  -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui",
        "veromix",
        "xtightvncviewer"
      },

      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester",  -- xev.
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "ConfigManager",  -- Thunderbird's about:config.
        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
      }
      },
      properties = { floating = true }
    },

    -- Remove titlebars from certain apps
    -- set titlebars on floating windows
    {
      rule_any = {
        name = { "kitty", "qutebrowser", "brave", "steam" },
      },
      properties = { titlebars_enabled = false }
    },

    -- Set windows to be maximized
    --{
    --  rule_any = {
    --    name = {"qutebrowser", "brave"}
    --  },
    --  properties = {
    --    maximized_vertical = true,
    --    maximized_horizontal = true
    --  }
    --},

    -- Set windows to be fullscreen
    {
      rule_any = {
        name = {
          "EVE",
          --"exefile.exe",
        }
      },
      properties = {
        fullscreen = true,
      }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}

return M
