const path = require('path')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const TerserPlugin = require('terser-webpack-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')

module.exports = (env, options) => {
  const devMode = options.mode !== 'production'

  return {
    entry: {
      app: ['./scripts/app.js']
    },

    output: {
      filename: '[name].js',
      path: path.resolve(__dirname, '../priv/static/scripts'),
      publicPath: '/scripts/'
    },

    devtool: devMode ? 'source-map' : undefined,

    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader'
          }
        },
        {
          test: /\.[s]?css$/,
          use: [
            MiniCssExtractPlugin.loader,
            'css-loader',
            'sass-loader'
          ]
        }
      ]
    },

    optimization: {
      minimizer: [
        new TerserPlugin({ parallel: true }),
        new OptimizeCSSAssetsPlugin({})
      ]
    },

    plugins: [
      new MiniCssExtractPlugin({ filename: '../styles/app.css' }),
      new CopyWebpackPlugin({
        patterns: [{ from: 'static/', to: '../' }]
      })
    ]
  }
}
