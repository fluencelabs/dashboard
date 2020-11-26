const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin')
const webpack = require('webpack');
const { WebpackPluginServe: Serve } = require('webpack-plugin-serve');

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
        historyApiFallback: {
            rewrites: [
                {from: /^\/$/, to: '/index.html'},
                {from: /./, to: '/index.html'}
            ]
        }
    },
    devtool: "eval-source-map",
    module: {
        rules: [
            {
                test: /\.html$/,
                use: [{loader: "file-loader?name=[name].[ext]"}]

            },
            {
                test: [/\.elm$/],
                exclude: [/elm-stuff/, /node_modules/],
                use: [
                    {loader: "elm-hot-webpack-loader"},
                    {
                        loader: "elm-webpack-loader",
                        options:
                            {debug: false, forceWatch: false}
                    }
                ]
            },
            {test: /\.ts$/, loader: "ts-loader"},
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
    watch: true,
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'bundle'),
        publicPath: "/"
    },
    plugins: [
        new CopyWebpackPlugin({
            patterns: [
                {from: './*.html'},
                // {from: './images/*.png'},
            ]
        }),
        new webpack.ProvidePlugin({
            process: 'process/browser.js',
            Buffer: ['buffer', 'Buffer'],
        }),
        new Serve({
            historyFallback: true,
            port: 55553
        })
    ]
};

