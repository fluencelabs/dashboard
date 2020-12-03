const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const webpack = require('webpack');
const { WebpackPluginServe: Serve } = require('webpack-plugin-serve');
const TerserPlugin = require('terser-webpack-plugin');

module.exports = (env, argv) => {
    const isDebug = argv.mode === 'development';
    const isProduction = argv.mode === 'production';

    return {
        entry: {
            app: ['./src/index.ts'],
        },
        resolve: {
            extensions: ['.js', '.ts', '.elm'],
        },
        devServer: {
            contentBase: './bundle',
            hot: false,
            inline: false,
        },
        devtool: 'eval-source-map',
        module: {
            rules: [
                {
                    test: /\.html$/,
                    use: [{ loader: 'file-loader?name=[name].[ext]' }],
                },
                {
                    test: [/\.elm$/],
                    exclude: [/elm-stuff/, /node_modules/],
                    use: [
                        { loader: 'elm-hot-webpack-loader' },
                        {
                            loader: 'elm-webpack-loader',
                            options: {
                                debug: isDebug,
                                optimize: isProduction,
                                forceWatch: false,
                            },
                        },
                    ],
                },
                { test: /\.ts$/, loader: 'ts-loader' },
                {
                    test: /\.(png)$/,
                    loader: 'file-loader',
                },
                {
                    test: /\.css$/i,
                    use: ['style-loader', 'css-loader'],
                },
            ],
        },
        mode: 'development',
        watch: true,
        output: {
            filename: 'bundle.js',
            path: path.resolve(__dirname, 'bundle'),
            publicPath: '/',
        },
        optimization: {
            minimize: isProduction,
            minimizer: [new TerserPlugin()],
        },
        plugins: [
            new CopyWebpackPlugin({
                patterns: [{ from: './*.html' }, { from: './images/*.svg' }],
            }),
            new webpack.ProvidePlugin({
                process: 'process/browser.js',
                Buffer: ['buffer', 'Buffer'],
            }),
            new Serve({
                historyFallback: true,
                port: 55553,
                host: 'localhost',
            }),
        ],
    };
};
