const merge = require('webpack-merge');
const baseConfig = require('./base.config');

module.exports = merge(baseConfig, {
  mode: 'development',
  devServer: {
    host: 'localhost',
    port: 80,
    open: true,
  },
});
