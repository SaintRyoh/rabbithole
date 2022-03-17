local _MODREV, _SPECREV = '1.0', '-1'

package = 'std.functional'
version = _MODREV .. _SPECREV

description = {
   summary = 'Functional Programming with Lua',
   detailed = [[
      An immutable tuple object, and many higher-order functions to help
      program in a functional style using tuples and Lua tables.
   ]],
   homepage = 'http://lua-stdlib.github.io/functional',
   license = 'MIT/X11',
}

dependencies = {
   'lua >= 5.1, < 5.5',
   'std.normalize >= 2.0.3',
}

source = {
   url = 'http://github.com/lua-stdlib/functional/archive/v' .. _MODREV .. '.zip',
   dir = 'functional-' .. _MODREV,
}

build = {
   type = 'builtin',
   modules = {
      ['std.functional'] = 'lib/std/functional/init.lua',
      ['std.functional._base'] = 'lib/std/functional/_base.lua',
      ['std.functional.operator'] = 'lib/std/functional/operator.lua',
      ['std.functional.tuple'] = 'lib/std/functional/tuple.lua',
      ['std.functional.version'] = 'lib/std/functional/version.lua',
   },
   copy_directories = {'doc'},
}

if _MODREV == 'git' then
   build.copy_directories = nil

   source = {
      url = 'git://github.com/lua-stdlib/functional.git',
   }
end
