const path = require('path');
const { execSync } = require("child_process");
const glob  = require('glob').sync

if (!process.env.THEME) {
  throw "tailwind.config.js: missing process.env.THEME"
  process.exit(1)
}
  
const themeConfigFile = execSync(`bundle exec bin/theme tailwind-config ${process.env.THEME}`).toString().trim()
let themeConfig = require(themeConfigFile)

// *** Uncomment these if required for your overrides ***

//const defaultTheme = require('tailwindcss/defaultTheme')
//const colors = require('tailwindcss/colors')

// *** Add your own overrides here ***

// themeConfig.theme.extend.fontFamily.sans = ['Custom Font Name', ...themeConfig.theme.extend.fontFamily.sans]
// themeConfig.theme.extend.fontSize['2xs'] = '.75rem'
// themeConfig.content.push('./app/additional/path')
// themeConfig.plugins.push(require('additional-tailwind-plugin'))

module.exports = themeConfig
module.exports = {
  safelist: [
    'bg-red-500',
    'bg-blue-500',
    'bg-yellow-500',
    'bg-green-500',
    'bg-green-800'
  ],
  // other Tailwind config...


};

themeConfig.safelist = [
  'bg-red-600',
  'bg-blue-400',
  'bg-yellow-400',
  'bg-green-400',
  'bg-green-700'
];
