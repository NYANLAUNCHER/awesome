require('defs')
local M={}
M.modkey = 'Mod4'
M.altkey = 'Mod1'

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

-- Desktop Buttons
M.buttons = gears.table.join(
  awful.button({ }, 3, function () mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
)

-- Key bindings
M.globalkeys = gears.table.join(
    awful.key({ M.modkey }, 's', hotkeys_popup.show_help,
              {description='show help', group='awesome'}),
    awful.key({ M.modkey }, 'h', awful.tag.viewprev,
              {description = 'view previous', group = 'tag'}),
    awful.key({ M.modkey }, 'l', awful.tag.viewnext,
              {description = 'view next', group = 'tag'}),
    awful.key({ M.modkey }, 'Escape', awful.tag.history.restore,
              {description = 'go back', group = 'tag'}),

    awful.key({ M.modkey }, 'j',
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = 'focus next by index', group = 'client'}
    ),
    awful.key({ M.modkey }, 'k',
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = 'focus previous by index', group = 'client'}
    ),
    --awful.key({ M.modkey }, 'w', function () mymainmenu:show() end,
    --          {description = 'show main menu', group = 'awesome'}),

    -- Layout manipulation
    awful.key({ M.modkey, 'Shift'   }, 'j', function () awful.client.swap.byidx(  1)    end,
              {description = 'swap with next client by index', group = 'client'}),
    awful.key({ M.modkey, 'Shift'   }, 'k', function () awful.client.swap.byidx( -1)    end,
              {description = 'swap with previous client by index', group = 'client'}),
    awful.key({ M.modkey, 'Control' }, 'j', function () awful.screen.focus_relative( 1) end,
              {description = 'focus the next screen', group = 'screen'}),
    awful.key({ M.modkey, 'Control' }, 'k', function () awful.screen.focus_relative(-1) end,
              {description = 'focus the previous screen', group = 'screen'}),
    awful.key({ M.modkey }, 'u', awful.client.urgent.jumpto,
              {description = 'jump to urgent client', group = 'client'}),
    awful.key({ M.altkey,           }, 'Tab',
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = 'swap between 2 clients', group = 'client'}),
    awful.key({ M.modkey }, 'Tab',
        function ()
          awful.tag.history.restore(s, 1)
        end,
        {description = 'swap between 2 tags', group = 'client'}),

    -- Standard program
    awful.key({ M.modkey }, 'Enter', function () awful.spawn(apps.terminal) end,
              {description = 'open terminal', group = 'launcher'}),
    awful.key({ M.modkey, 'Control' }, 'r', awesome.restart,
              {description = 'reload awesome', group = 'awesome'}),
    --  prompt y/n before executing
    awful.key({ M.modkey, 'Control' }, 'q', awesome.quit,
              {description = 'quit awesome', group = 'awesome'}),

    awful.key({ M.modkey }, 'Right',     function () awful.tag.incmwfact( 0.025)     end,
              {description = 'increase master width factor', group = 'layout'}),
    awful.key({ M.modkey }, 'Left',     function () awful.tag.incmwfact(-0.025)      end,
              {description = 'decrease master width factor', group = 'layout'}),
    awful.key({ M.modkey, 'Shift'   }, 'h',     function () awful.tag.incnmaster( 1, nil, true) end,
              --{description = 'cycle previous tag', group = 'layout'}),
              {description = 'increase the number of master clients', group = 'layout'}),
    awful.key({ M.modkey, 'Shift'   }, 'l',     function () awful.tag.incnmaster(-1, nil, true) end,
              --{description = 'cycle next tag', group = 'layout'}),
              {description = 'decrease the number of master clients', group = 'layout'}),
    awful.key({ M.modkey, 'Control' }, 'h',     function () awful.tag.incncol( 1, nil, true)    end,
              {description = 'increase the number of columns', group = 'layout'}),
    awful.key({ M.modkey, 'Control' }, 'l',     function () awful.tag.incncol(-1, nil, true)    end,
              {description = 'decrease the number of columns', group = 'layout'}),
    awful.key({ M.modkey }, 'space', function () awful.layout.inc( 1)                end,
              {description = 'select next layout', group = 'layout'}),
    awful.key({ M.modkey, 'Shift'   }, 'space', function () awful.layout.inc(-1)                end,
              {description = 'select previous layout', group = 'layout'}),

    awful.key({ M.modkey, 'Control' }, 'n',
      function ()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
          c:emit_signal(
            'request::activate', 'key.unminimize', {raise = true}
          )
        end
      end,
      {description = 'restore minimized', group = 'client'}),

    awful.key({ M.modkey }, 'x',
      function ()
        awful.prompt.run {
          prompt       = 'Run Lua code: ',
          textbox      = awful.screen.focused().mypromptbox.widget,
          exe_callback = awful.util.eval,
          history_path = awful.util.get_cache_dir() .. '/history_eval'
        }
      end,
      {description = 'lua execute prompt', group = 'awesome'}),

    -- Menubar
    awful.key({ M.modkey }, 'p', function() menubar.show() end,
              {description = 'native app launcher', group = 'launcher'})
    --awful.key({ M.modkey }, 'g', function() menubar.show() end,
    --          {description = 'goto tag/window', group = 'launcher'})
)

M.clientkeys = gears.table.join(
    awful.key({ M.modkey }, 'f',
      function (c)
        c.fullscreen = not c.fullscreen
        c:raise()
      end,
      {description = 'toggle fullscreen', group = 'client'}),
    awful.key({ M.modkey, 'Shift'   }, 'c',      function (c) c:kill()                         end,
              {description = 'close window', group = 'client'}),
    --awful.key({ M.modkey, 'Control' }, 'space',  awful.client.floating.toggle                     ,
    --          {description = 'toggle floating', group = 'client'}),
    awful.key({ M.modkey, 'Control' }, 'Return', function (c) c:swap(awful.client.getmaster()) end,
              {description = 'move to master', group = 'client'}),
    awful.key({ M.modkey }, 'o',      function (c) c:move_to_screen()               end,
              {description = 'move to screen', group = 'client'}),
    awful.key({ M.modkey }, 't',      function (c) c.ontop = not c.ontop            end,
              {description = 'toggle keep on top', group = 'client'}),
    awful.key({ M.modkey }, 'n',
      function (c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
      end ,
      {description = 'minimize', group = 'client'}),
    awful.key({ M.modkey }, 'm',
      function (c)
        c.maximized = not c.maximized
        c:raise()
      end ,
      {description = '(un)maximize', group = 'client'}),
    awful.key({ M.modkey, 'Control' }, 'm',
      function (c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
      end ,
      {description = '(un)maximize vertically', group = 'client'}),
    awful.key({ M.modkey, 'Shift'   }, 'm',
      function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
      end ,
      {description = '(un)maximize horizontally', group = 'client'})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
function M.keystotags()
  for i = 1, 9 do
    M.globalkeys = gears.table.join(M.globalkeys,
      -- View tag only.
      awful.key({ M.modkey }, '#' .. i + 9,
        function ()
          local screen = awful.screen.focused()
          local tag = screen.tags[i]
          if tag then
            tag:view_only()
          end
        end,
        {description = 'view tag #'..i, group = 'tag'}),
      -- Toggle tag display.
      awful.key({ M.modkey, 'Control' }, '#' .. i + 9,
        function ()
          local screen = awful.screen.focused()
          local tag = screen.tags[i]
          if tag then
            awful.tag.viewtoggle(tag)
          end
        end,
        {description = 'toggle tag #' .. i, group = 'tag'}),
      -- Move client to tag.
      awful.key({ M.modkey, 'Shift' }, '#' .. i + 9,
        function ()
          if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
              client.focus:move_to_tag(tag)
            end
          end
        end,
        {description = 'move focused client to tag #'..i, group = 'tag'}),
      -- Toggle tag on focused client.
      awful.key({ M.modkey, 'Control', 'Shift' }, '#' .. i + 9,
        function ()
          if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
              client.focus:toggle_tag(tag)
            end
          end
          local screen = awful.screen.focused()
          local tag = screen.tags[i]
          if tag then
            tag:view_only()
          end
        end,
        {description = 'toggle focused client on tag #' .. i, group = 'tag'})
    )
  end
end

return M
