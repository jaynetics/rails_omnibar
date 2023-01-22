const path = require('path')

module.exports = {
  entry: './javascript/src/index.ts',
  mode: 'production',
  module: {
    rules: [
      {
        rules: [
          {
            test: /\.tsx?$/,
            use: 'ts-loader',
            exclude: /node_modules/,
          },
        ],
      }
    ]
  },
  resolve: {
    extensions: ['.tsx', '.ts', '.js'],
    alias: {
      "react": "preact/compat",
      "react-dom/test-utils": "preact/test-utils",
      "react-dom": "preact/compat",     // Must be below test-utils
      "react/jsx-runtime": "preact/jsx-runtime"
    },
  },
  output: {
    filename: 'compiled.js',
    path: path.resolve(__dirname, 'javascript'),
  },
}
