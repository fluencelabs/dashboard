const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin')

module.exports = {
    entry: {
        app: ['./src/index.ts']
    },
    resolve: {
        extensions: ['.js', '.ts', ".elm"]
    },
    devServer: {
        contentBase: './bundle',
        hot: false,
        inline: false,
        historyApiFallback:{
            index:'index.html'
        },
    },
    devtool: "eval-source-map",
    module: {
        rules: [
            {
                test: /\.html$/,
                exclude: /node_modules/,
                loader: "file-loader?name=[name].[ext]"
            },
            {
                test: [/\.elm$/],
                exclude: [/elm-stuff/, /node_modules/],
                use: [
                    { loader: "elm-hot-webpack-loader" },
                    {
                        loader: "elm-webpack-loader",
                        options:
                            { debug: false, forceWatch: true }
                    }
                ]
            },
            { test: /\.ts$/, loader: "ts-loader" },
            {
                test: /\.(png)$/,
                loader: 'file-loader',
            },
          {
            test: /\.css$/i,
            use: ['style-loader', 'css-loader'],
          },
        ]
    },
    mode: "development",
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'bundle')
    },
    plugins: [
        new CopyWebpackPlugin([{
            from: './*.html'
        }]),
        new CopyWebpackPlugin([{
            from: './images/*.png'
        }])
    ]
};

