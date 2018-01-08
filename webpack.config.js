const path              = require("path");
const glob              = require("glob");
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const webpack           = require('webpack');

const isDev = process.env.ENV === "development";
const outDirAbs = path.resolve(`${__dirname}/client/public/assets`); // Files are openly accessible from here
const extractTextPlugin = new ExtractTextPlugin(`[name].css`);

//TODO: Setup caching and live reload
//TODO: Do asset copying properly
module.exports = [{
  name: 'Code',
  devtool: isDev ? 'source-map' : false,
  entry: {
      index: [ './client/src/index.js', './client/src/index.html', './client/src/github.svg','./client/src/elm.svg' ], 
      event: [ './client/src/event.js']
  },

  output: {
      path: outDirAbs,
      filename: '[name].js',
    },

module: {
  rules: [
    {
      test:    /\.html$/,
      exclude: /node_modules/,
      use: {
          loader: 'file-loader',
          options: {
              name: '../[name].[ext]'
          }
      }
    },
    {
      test:    /\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      use: {
          loader: 'elm-webpack-loader',
          options: {
              verbose: true,
              warn: true
          }
      }
    },
    {
      test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
      use: {
          loader: 'url-loader',
          options: {
              limit: 10000,
              mimetype: "application/font-woff"
          }
      }
    },
    {
      test: /\.(ttf|eot|svg|eps)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
      use: {
          loader: 'file-loader',
          options: {
              name: '[name].[ext]'
          }
      }
    },
  ],
  noParse: /\.elm$/,
}
},{
name: 'Styles',
entry: {
  'index': path.resolve('./client/src/index.scss')
},
output: {
  path: outDirAbs,
  publicPath: '/assets/', // Used by webpack-dev-server
  filename: `[name].min.css`,
},
devtool: isDev ? 'source-map' : false,
module: {
  rules: [{
    test: /\.scss$/,
    use: extractTextPlugin.extract({
        fallback: 'style-loader',
        use: [
            {
              loader: 'css-loader',
              options: {
                sourceMap: false,
              },
            },
            {
              loader: 'postcss-loader',
              options: {
                sourceMap: false,
                plugins: () => [require('autoprefixer')({grid: false})],
              },
            },
            {
              loader: 'sass-loader',
              options: {
                sourceMap: false,
                includePaths: glob.sync('./node_modules').map((d) => {
                    console.log(path.join(__dirname, d))
                    return path.join(__dirname, d);
                }),
              },
            },
          ]
      })
  }]
},
plugins: [ extractTextPlugin ],
}];