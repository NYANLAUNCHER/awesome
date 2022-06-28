-- defs to get included in (most of) my awesome configs

-- Nicer linting
awesome, client, mouse, screen, tag, root = awesome, client, mouse, screen, tag, root
ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

-- Standard awesome libraries
gears = require('gears')
awful = require('awful')

-- Widget and layout library
wibox = require('wibox')

-- Theme handling library
beautiful = require('beautiful')

-- Notification library
naughty = require('naughty')
menubar = require('menubar')
hotkeys_popup = require('awful.hotkeys_popup')

-- External Modules
lain = require('lain')

-- Default Dirs
HOME_DIR=os.getenv('HOME')

-- Default Programs
--- this is the fallback if mime type doesn't work
apps = {
  terminal = 'kitty',
  editor = os.getenv('EDITOR') or 'nvim',
  geditor = 'emacs', -- gui text editor
  browser = 'qutebrowser',
  viewer = {
    image = 'sxiv',
    video = 'mpv',
    audio = 'mpv',
    pdf = 'zathura',
  }
}

